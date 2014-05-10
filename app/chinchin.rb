##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/game'
require 'chinchin/player'

def view(result)
  if result.point
    head = result.outcome ? result.outcome : "Banker"
    point = result.yaku ? result.yaku : result.point
    dice = result.dice.inspect
    printf "%6s: #{result.player.name} <#{point}> #{dice}\n", head
  else
    printf "%6s: #{result.player.name}\n", result.outcome
  end
end

banker  = ChinChin::Player.new("banker")
punter1 = ChinChin::Player.new("punter1")
punter2 = ChinChin::Player.new("punter2")
punter3 = ChinChin::Player.new("punter3")
game = ChinChin::Game.new(banker, punter1, punter2, punter3)

game.banker = banker
results = game.play
results.each do |result|
  if result.player == banker
    view(result)
    puts "-------"
  else
    view(result)
  end
end
