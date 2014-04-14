##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/player'
require 'chinchin/result'

player1 = ChinChin::Player.new(ChinChin::Result)
player2 = ChinChin::Player.new(ChinChin::Result)

result1 = player1.thow
result2 = player2.thow

puts "Player1::Dices: #{result1.dices}"
puts "Player2::Dices: #{result2.dices}"

puts "Player1::Score: #{result1.score}"
puts "Player2::Score: #{result2.score}"

geme_result = result1.score - result2.score
if geme_result == 0
  puts "Game was drawn."
else
  if geme_result > 0
    puts "Game won by Player1."
  else
    puts "Game won by Player2."
  end
end
