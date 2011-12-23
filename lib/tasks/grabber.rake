# encoding: utf-8
namespace :grab do

  desc "Clean up"
  task :clean_up => :environment  do
    print "*** Чистим все ***\n"
    Commission.destroy_all
  end

  desc "Grab all the commissions out there from 4-dec elections"
  task :do => :environment do
        
    Rake::Task['grab:clean_up'].invoke
    
    require 'nokogiri'
    require 'open-uri'
    #Собираем то что идет после ЦИК-а (республики/области)
    agent = Nokogiri::HTML(open("http://www.vybory.izbirkom.ru/region/izbirkom?action=show&root_a=null&vrn=100100028713299&region=0&global=true&type=0&sub_region=0&prver=0&pronetvd=null"), nil, 'Windows-1251')
    agent.search("select option").each_with_index do |option,index|      
      if (option['value'])      
        commission = Commission.create!(:name => option.content,:url => option['value'])        
        print "Taken: #{option.content}\n"
        # get_children(commission,commission.url)
        
      end
    end

    Parallel.each(Commission.all,:in_processes=>5){|commission| get_children(commission,commission.url)}
    
  end
  
  def get_children(parent_commission,url)
    #идем по урл, забираем html селект или переходим на сайт субъекта     
    begin
      agent = Nokogiri::HTML(open(url.gsub(/[_]/, '-')), nil, 'Windows-1251')

      agent.search("select option").each do |option|
        if option['value']
          name = option.content.gsub(/^\d+ /,'')
          child = parent_commission.children.create(:name => name, :url => option['value'], :is_uik => name.include?("УИК"))
          #move node to parent_commission
          print "Taken: #{name}\n"

          get_children(child,option['value'])
        end
      end
      agent.search("a").each do |href|
         if (href.content.to_str == "сайт избирательной комиссии субъекта Российской Федерации")
            get_children(parent_commission,href['href'])
        end
      end
      
      voting_table(agent,parent_commission)
    rescue Exception => ex
      print "Error: #{ex}\n"
    end       
  end
  
  def voting_table(agent,parent_commission)
    agent.search("a").search("a").each do |href|
      if (href.content.to_str == "Результаты выборов")
          begin
            url = href['href'].gsub(/[_]/, '-')
            agent = Nokogiri::HTML(open(url), nil, 'Windows-1251')          
            voting_table = Hash.new
            agent.search("table").each do |table|
              table.search("tr").each do |row|
                arr = row.search('td').map{ |n| n }
                voting_table[:poll]                   = arr[2].text.to_i if (arr[0].text.to_i==1)
                voting_table[:received_by_commission] = arr[2].text.to_i if (arr[0].text.to_i==2)
                voting_table[:voted_early]            = arr[2].text.to_i if (arr[0].text.to_i==3)
                
                voting_table[:voted_in]               = arr[2].text.to_i if (arr[0].text.to_i==4)
                voting_table[:voted_out]              = arr[2].text.to_i if (arr[0].text.to_i==5)
                voting_table[:canceled_ballots]       = arr[2].text.to_i if (arr[0].text.to_i==6)
                voting_table[:mobile_ballots]         = arr[2].text.to_i if (arr[0].text.to_i==7)
                voting_table[:stationary_ballots]     = arr[2].text.to_i if (arr[0].text.to_i==8)
                voting_table[:invalid_ballots]        = arr[2].text.to_i if (arr[0].text.to_i==9)                
                voting_table[:valid_ballots]          = arr[2].text.to_i if (arr[0].text.to_i==10)  

                voting_table[:absentee_ballots_all]   = arr[2].text.to_i if (arr[0].text.to_i==11)  
                voting_table[:absentee_ballots_given] = arr[2].text.to_i if (arr[0].text.to_i==12)
                voting_table[:absentee_ballots_voted] = arr[2].text.to_i if (arr[0].text.to_i==13)                
                voting_table[:unused_absentee_ballots]= arr[2].text.to_i if (arr[0].text.to_i==14)                
                voting_table[:absentee_territorial]   = arr[2].text.to_i if (arr[0].text.to_i==15)   
                voting_table[:lost_absentee_ballots]  = arr[2].text.to_i if (arr[0].text.to_i==16)
                voting_table[:ballots_not_taken]      = arr[2].text.to_i if (arr[0].text.to_i==18)                 
                
                voting_table[:sr]           = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 19)
                voting_table[:ldpr]         = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 20)
                voting_table[:pr]           = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 21)
                voting_table[:kprf]         = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 22)
                voting_table[:yabloko]      = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 23)
                voting_table[:er]           = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 24)
                voting_table[:pd]           = arr[2].first_element_child().text.to_i if (arr[0].text.to_i == 25)                
              end          
            end
             parent_commission.update_attributes(voting_table)
             # parent_commission.save
           rescue Exception => ex
              print "Error: #{ex}\n"
           end  
        end
      end
  end
  
end
