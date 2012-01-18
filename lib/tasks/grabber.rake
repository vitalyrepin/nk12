# encoding: utf-8
namespace :grab do

  desc "Clean up"
  task :clean_up => :environment  do
    print "*** Чистим все ***\n"
    Election.destroy_all
    Commission.destroy_all
  end

  desc "Get ungetted"
  task :get_lost => :environment do
        
    require 'net/http'
    require 'nokogiri'
    require 'open-uri'
    require 'pp'

    @voting_dictionaries = Hash.new
    Election.first.voting_dictionaries.each do |dict|
      @voting_dictionaries[dict[:source_identifier]] = dict[:id]
    end    
    # Parallel.each(Commission.where(:is_uik => true), :in_threads => 20){|commission| voting_table(commission) if commission.votings.empty? }    
    Commission.where(:is_uik => true).each do |commission|
      if commission.votings.empty?
        print "#{commission.name}\n"
        print "#{commission.url}\n"
        # voting_table(commission) 
      end
    end
  end

  desc "Grab all the commissions out there from 4-dec elections"
  task :get => :environment do        
    Rake::Task['grab:clean_up'].invoke
    
    beginning_time = Time.now
    
    require 'net/http'
    require 'nokogiri'
    require 'open-uri'
    require 'pp'

        
    @election = Election.create!(:name => "Выборы депутатов Государственной Думы Федерального Собрания Российской Федерации шестого созыва", :url => "http://www.vybory.izbirkom.ru/region/izbirkom?action=show&root_a=null&vrn=100100028713299&region=0&global=true&type=0&sub_region=0&prver=0&pronetvd=null")

    #Хеш имен и их индексов в таблицх голосований (меняется на каждых выборах)
    voting_names = {"poll"=>1,"received_by_commission"=>2,"voted_early"=>3,"voted_in"=>4,"voted_out"=>5,"canceled_ballots"=>6,"mobile_ballots"=>7,"stationary_ballots"=>8,"invalid_ballots"=>9,"valid_ballots"=>10,"absentee_ballots_all"=>11,"absentee_ballots_given"=>12,"absentee_ballots_voted"=>13,"unused_absentee_ballots"=>14,"absentee_territorial"=>15,"lost_absentee_ballots"=>16,"ballots_not_taken"=>18,"sr"=>19,"ldpr"=>20,"pr"=>21,"kprf"=>22,"yabloko"=>23,"er"=>24,"pd"=>25}
    voting_labels = {"poll" => "Число избирательных бюллетеней, полученных участковой избирательной комиссией","received_by_commission" => "Число избирательных бюллетеней, выданных избирателям, проголосовавшим досрочно","voted_early" => "Число избирательных бюллетеней, выданных избирателям в помещении для голосования","voted_in" => "Число избирательных бюллетеней, выданных избирателям вне помещения для голосования","voted_out" => "Число погашенных избирательных бюллетеней","canceled_ballots" => "Число избирательных бюллетеней в переносных ящиках для голосования","mobile_ballots" => "Число избирательных бюллетеней в стационарных ящиках для голосования","stationary_ballots" => "Число недействительных избирательных бюллетеней","invalid_ballots" => "Число действительных избирательных бюллетеней","valid_ballots" => "Число открепительных удостоверений, полученных участковой избирательной комиссией","absentee_ballots_all" => "Число открепительных удостоверений, выданных избирателям на избирательном участке","absentee_ballots_given" => "Число избирателей, проголосовавших по открепительным удостоверениям на избирательном участке","absentee_ballots_voted" => "Число погашенных неиспользованных открепительных удостоверений","unused_absentee_ballots" => "Число открепительных удостоверений, выданных избирателям территориальной избирательной комиссией","absentee_territorial" => "Число утраченных открепительных удостоверений","lost_absentee_ballots" => "Число утраченных избирательных бюллетеней","ballots_not_taken" => "Число избирательных бюллетеней, не учтенных при получении","sr" => "Политическая партия СПРАВЕДЛИВАЯ РОССИЯ","ldpr" => "Политическая партия Либерально-демократическая партия России","pr" => "Политическая партия ПАТРИОТЫ РОССИИ","kprf" => "Политическая партия Коммунистическая партия Российской Федерации","yabloko" => "Политическая партия Российская объединенная демократическая партия ЯБЛОКО","er" => "Всероссийская политическая партия ЕДИНАЯ РОССИЯ","pd" => "Всероссийская политическая партия ПРАВОЕ ДЕЛО"}
    
    @voting_dictionaries = Hash.new

    voting_labels.each do |key,value|
      voting_dictionary = @election.voting_dictionaries.create(:en_name => key, :name => value, :source_identifier => voting_names[key])  
      @voting_dictionaries[voting_names[key]] = voting_dictionary.id
    end
    

    agent = Nokogiri::HTML(open("http://www.vybory.izbirkom.ru/region/izbirkom?action=show&root_a=null&vrn=100100028713299&region=0&global=true&type=0&sub_region=0&prver=0&pronetvd=null"), nil, 'Windows-1251')
    agent.search("select option").each_with_index do |option,index|      
      if (option['value'])      
        commission = Commission.create!(:name => option.content,:url => option['value'], :election_id => @election.id)        
        print "Taken: #{option.content}\n"
        #get_children(commission,commission.url)        
      end
    end
    # commission = Commission.first
    # get_children(commission,commission.url)        


    Parallel.each(Commission.all, :in_threads => 15){|commission| get_children(commission,commission.url)}    
    
    # print "\n-- data taken, taken votes --\n"
            
    # Parallel.each(@election.commissions.where(:is_uik => true), :in_threads => 10){|commission| voting_table(commission)}

    # Parallel.each(Commission.all, :in_threads => /20){|commission| voting_table(commission)}    
  end  


  def url_normalize(url)
    host = url.match(".+\:\/\/([^\/]+)")[1]
    path = url.partition(host)[2] || "/"
    begin
      return Net::HTTP.get(host, path)
    rescue Timeout::Error
      print "timeout-error - sleeping 5 seconds"
      sleep 5
      url_normalize(url)
    end
  end
  
  def get_children(parent_commission,url)
    #идем по урл, забираем html селект или переходим на сайт субъекта     
    begin
      agent = Nokogiri::HTML(url_normalize(url), nil, 'Windows-1251')
      
      agent.search("a").search("a").each do |href|
        if (href.content.to_str == "Результаты выборов")
          parent_commission.voting_table_url = href['href']    
          parent_commission.save          
        end
      end

      agent.search("select option").each do |option|
        if option['value']
          name = option.content.gsub(/^\d+ /,'')
          child = parent_commission.children.create(:name => name, :url => option['value'], :is_uik => name.include?("УИК"), :election_id => @election.id)
                              
          if name.include?("УИК")
            #ставим флаг, что коммиссия содержит уики
            parent_commission.update_attributes(:uik_holder => true)                                     
          else
            print "Taken: #{name}\n"
          end                    
          get_children(child,option['value'])
        end
      end
      agent.search("a").each do |href|
         if (href.content.to_str == "сайт избирательной комиссии субъекта Российской Федерации")
            get_children(parent_commission,href['href'])
        end
      end      
      voting_table(parent_commission)
    rescue Exception => ex
      print "Error: #{ex}\n"
    end             
    
  end
  
  def voting_table(commission)    
    if commission.voting_table_url
      begin            
        agent_inner = Nokogiri::HTML(url_normalize(commission.voting_table_url), nil, 'Windows-1251')          
        voting_table = Hash.new
        rows = agent_inner.xpath('//table/tr')
        details = rows.collect do |row|                            
          tds = row.xpath('td')
          if (tds.first.text.to_i > 0)   
            if @voting_dictionaries.has_key?(tds.first.text.to_i) 
              # добавляем голоса в коммисию
              
              commission.votings.build(:votes => tds.last.first_element_child().text.to_i, :voting_dictionary_id => @voting_dictionaries[tds.first.text.to_i])                             
              
            end 
          end              
        end        
        commission.votes_taken = true            
        commission.save                    
              
       rescue Exception => ex
          print "Error: #{ex}\n"
       end  
    end
  end
  
end
