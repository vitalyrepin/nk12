# encoding: utf-8
class VerifyController < ApplicationController
  def index
    @result = Array.new
    # commission = Commission.roots.first
    # Commission.roots.each do |commission|
      # commission.children.each {|child| tree_travel(commission)}
    # end
    # @result.uniq!

    # new stuff
    
  
      Commission.where(:uik_holder=>true).each do |uik_holder|        
        result = 0
        
        uik_holder.children.each do |uik_child|
          if uik_child.votings.exists?
            result = uik_child.votings.where(:voting_dictionary_id => 1).first.votes + result
          end
          # p uik_child.votings
        end
        
        if uik_holder.votings.exists? and uik_holder.votings.where(:voting_dictionary_id => 1).first.votes != result
          # print "#{uik_holder.name} | #{uik_holder.votings.first.votes} | #{result}\n" 
          uik_holder[:num_calc] = result
          @result << uik_holder
        end
      end
    
  end
  
  def tree_travel(commission)
    sum_result = Hash.new
    commission.children.each do |child|
      if child.has_children?
        tree_travel(child)
      else
        if child.is_uik
          #складываем данные по уикам
          sum_result[:poll] = sum_result[:poll].to_i + child[:poll].to_i
          sum_result[:name] = child.name
        end
      end
    end
    
    if sum_result[:poll] != commission[:poll] && !sum_result.empty?
      @result << {:name => commission[:name], :poll => commission[:poll], :summed_poll => sum_result[:poll]}
    end
    
  end
  def index_old
    @result = Array.new
    @trash = Array.new
    @commission = Commission.roots.first
    @commission.children.each do |child|
      @tmp = Hash.new
      @tmp[:name] = child.name
      @tmp[:poll_from_cik] = child.poll
      if child.has_children?
        child.children.each do |uik|

          @tmp[:poll] = uik.poll.to_i + @tmp[:poll].to_i
          @trash << uik[:name].gsub(/[УИК №]/,'')
        end
      end


      @result << @tmp
      
    end
          p @trash
          245.times do |i|
            p i if !@trash.include?(i.to_s)
            
          end
  end

end
