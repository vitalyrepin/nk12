# encoding: utf-8
class VerifyController < ApplicationController
  def index
    @result = Array.new
    # commission = Commission.roots.first
    Commission.roots.each do |commission|
      commission.children.each {|child| tree_travel(commission)}
    end
    @result.uniq!
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
