#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require "chinchin/constants"
require "chinchin/game"
require "chinchin/player"
require "chinchin/players"

DEFAULT_POINT = 5

include ChinChin::Constants

def point_by(yaku)
  case yaku
  when Yaku::ARASHI
    DEFAULT_POINT * 3
  when Yaku::SHIGORO
    DEFAULT_POINT * 2
  when Yaku::HIFUMI
    DEFAULT_POINT * 2
  else
    DEFAULT_POINT
  end
end

def view(result)
  if result.point
    head = result.outcome ? result.outcome : "Banker"
    point = result.yaku ? result.yaku : result.point
    dice = result.dice.inspect

    printf "%3d %6s: #{result.player.name} <#{point}> #{dice}\n",
           result.player.tokens, head
  else
    printf "%3d %6s: #{result.player.name}\n",
           result.player.tokens, result.outcome
  end
end

def play(game)
  results = game.play
  results[:punters].each do |result|
    point = point_by(
      results[:banker].yaku ? results[:banker].yaku : result.yaku)

    case result.outcome
    when Outcome::WIN
      game.banker.decrement_tokens point
      result.player.increment_tokens point
    when Outcome::LOST
      game.banker.increment_tokens point
      result.player.decrement_tokens point
    else
    end
    view(result)
  end
  puts "-------"
  view(results[:banker])
end

def start(game)
  loop do
    puts
    play(game)
    puts
    print '[input "quit" or "exit" to quit] '
    pless_key = gets
    break if pless_key.is_a?(String) && /\A[qecb]/i =~ pless_key
  end
end

banker  = ChinChin::Player.new("banker")
punter1 = ChinChin::Player.new("punter1")
punter2 = ChinChin::Player.new("punter2")
punter3 = ChinChin::Player.new("punter3")
players = ChinChin::Players.new(banker, punter1, punter2, punter3)
game = ChinChin::Game.new(players)
game.banker = banker

start(game)
