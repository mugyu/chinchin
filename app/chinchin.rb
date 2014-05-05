##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/game'
require 'chinchin/player'
require 'chinchin/result'

def judge(game, banker_result, punter)
  return [:Win]  if banker_result.point < 2
  return [:Lost] if banker_result.point > 5

  result = game.play(punter)
  return [:Draw, result] if banker_result.point == result.point
  return [:Win,  result] if banker_result.point < result.point
  return [:Lost, result]
end

def view(player, head, result = nil)
  if result
    printf "%6s: #{player.name} <#{result.yaku ? result.yaku : result.point}> #{result.dice.inspect}\n", head
  else
    printf "%6s: #{player.name}\n", head
  end
end

def punters_list(game, banker_result)
  game.punters.each do |punter|
    view(punter, *(judge(game, banker_result, punter)))
  end
end

banker  = ChinChin::Player.new("banker",  ChinChin::Result)
punter1 = ChinChin::Player.new("punter1", ChinChin::Result)
punter2 = ChinChin::Player.new("punter2", ChinChin::Result)
punter3 = ChinChin::Player.new("punter3", ChinChin::Result)
game = ChinChin::Game.new(banker, punter1, punter2, punter3)

game.banker = banker
banker_result = game.play(game.banker)
view(game.banker, "Banker", banker_result)
puts "-------"
punters_list(game, banker_result)
