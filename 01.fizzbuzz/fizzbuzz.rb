#!/usr/bin/env ruby

def fizzbuzz
  (1..20).each {|num|
    if (num % 3)== 0 && (num % 5)== 0
      puts "FizzBuzz"
    elsif (num % 5)== 0
      puts "Buzz"
    elsif (num % 3)== 0
      puts "Fizz"
    else
      puts num
    end
  }
end

fizzbuzz
