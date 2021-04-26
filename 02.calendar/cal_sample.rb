#!/usr/bin/env ruby

require 'date'
require 'optparse'

class Calendar
  def initialize
    opt = OptionParser.new
    params = opt.getopts('', "y:#{Date.today.year}","m:#{Date.today.month}")
    @year = params['y'].to_i
    @month = params['m'].to_i
    fetch_date
  end

  def output
    output_calendar_header
    @rawdays.each do |oneday|
      print ' ' * (3 * oneday.wday) if oneday.day == 1
      print "#{oneday.day.to_s.rjust(2)} "
      print "\n" if oneday.saturday?
    end
    puts "\n\n"
  end

  private
  
  def fetch_date
    first_day = 1
    last_day = Date.new(@year, @month, -1).day
    @rawdays = [*(first_day..last_day)].map do |day|
      Date.new(@year, @month, day)
    end
  end

  def output_calendar_header
    puts "#{@month}月 #{@year}年".center(20)
    puts ['日', '月' ,'火', '水', '木', '金', '土'].join(" ")
  end
end

Calendar.new.output
