##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/game'
require 'chinchin/player'

def view(player, head, result = nil)
  if result
    printf "%6s: #{player.name} <#{result.yaku ? result.yaku : result.point}> #{result.dice.inspect}\n", head
  else
    printf "%6s: #{player.name}\n", head
  end
end

banker  = ChinChin::Player.new("banker")
punter1 = ChinChin::Player.new("punter1")
punter2 = ChinChin::Player.new("punter2")
punter3 = ChinChin::Player.new("punter3")
game = ChinChin::Game.new(banker, punter1, punter2, punter3)

game.banker = banker
result = game.game
result.each do |score|
  if score[:player] == banker
    view(score[:player], "Banker", score[:result])
    puts "-------"
  else
    view(score[:player], score[:status], *(score[:result]))
  end
end
