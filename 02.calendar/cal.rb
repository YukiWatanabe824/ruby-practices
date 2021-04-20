#!/usr/bin/env ruby

require "date"
require "optparse"

class Calendar
  #コマンドラインからの情報を取得&デフォルトで現在日を指定
  def initialize
    opt = OptionParser.new
    params = opt.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")
    @year = params["y"].to_i
    @month = params["m"].to_i
    fetch_date
  end

  #ヘッダー（年月表示、曜日表示）
  def calheader
    days = ["日", "月", "火", "水", "木", "金", "土"]
    puts "      #{(@month)}月 #{(@year)}年"
    puts days.join(" ")
  end

  #カレンダーの日にち取得
  def fetch_date(year = @year, month = @month)
    first_day = 1
    last_day = Date.new(year, month, -1).day
    @rawdays = [*(first_day..last_day)].map do |day|
      Date.new(year, month, day)
    end
  end

  #日にちをカレンダーの形式に合わせる
  def set_calendarstyle(rawdays = @rawdays)
    rawdays.each_with_index do |oneday, idx|
      #すべての日にちに半角スペースを追加
      day_halfspace = " " + oneday.day.to_s
      #一桁の日にちに半角スペースを追加
      if oneday.day < 10
        day_onedigitday_halfspace = " " + day_halfspace
      else
        day_onedigitday_halfspace = day_halfspace
      end
      #最初の日にちの位置を曜日に合わせる
      if idx == 0
        day_setting_wday_start = (" " * (oneday.wday * 2 + (oneday.wday - 1))) + day_onedigitday_halfspace
      else
        day_setting_wday_start = day_onedigitday_halfspace
      end

      #月曜日のスペースを一個除去
      if oneday.wday == 0
        if oneday.day < 10
          day_deleted_halfspace_monday = day_setting_wday_start.lstrip
          day_deleted_halfspace_monday = " " + day_deleted_halfspace_monday
        else
          day_deleted_halfspace_monday = day_setting_wday_start.lstrip
        end
      else
        day_deleted_halfspace_monday = day_setting_wday_start
      end

      #土曜日の日にちのあとに改行を追加
      if oneday.wday == 6
        print day_deleted_halfspace_monday + "\n"
      else
        print day_deleted_halfspace_monday
      end
    end
  end
  
  private
  #カレンダーの日にち取得
  def fetch_date(year = @year, month = @month)
    first_day = 1
    last_day = Date.new(year, month, -1).day
    @rawdays = [*(first_day..last_day)].map do |day|
      Date.new(year, month, day)
    end
  end
end

cal = Calendar.new

cal.calheader
cal.set_calendarstyle
puts "\n\n"
