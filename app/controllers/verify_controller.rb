# encoding: utf-8
class VerifyController < ApplicationController
  def index
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
