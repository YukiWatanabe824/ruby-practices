#! /usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

results = []
frames.each_with_index do |f, idx|
  f_sum = f.sum
  next_frame = idx <= 9 ? frames[idx + 1].sum : nil
  results << if f == [10, 0] && (idx < 8)
               if frames[idx + 1] == [10, 0]
                 f_sum + next_frame + frames[idx + 2][0]
               else
                 f_sum + next_frame
               end
             elsif f_sum == 10 && (idx < 8)
               f_sum + frames[idx + 1][0]
             else
               f_sum
             end
end

puts results.sum
