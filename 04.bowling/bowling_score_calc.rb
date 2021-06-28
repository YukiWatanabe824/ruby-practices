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

frames = shots.each_slice(2).to_a

results = []
frames.each_with_index do |f, idx|
  frame_score_sum = f.sum
  results << if f == [10, 0] && (idx < 9)
               if frames[idx + 1] == [10, 0]
                 frame_score_sum + frames[idx + 1].sum + frames[idx + 2][0]
               else
                 frame_score_sum + frames[idx + 1].sum
               end
             elsif frame_score_sum == 10 && (idx < 9)
               frame_score_sum + frames[idx + 1][0]
             else
               frame_score_sum
             end
end

puts results.sum
