##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/game'
require 'chinchin/player'
require 'chinchin/result'

computer = ChinChin::Player.new(ChinChin::Result)
you = ChinChin::Player.new(ChinChin::Result)
game = ChinChin::Game.new(computer, you)

def judge(com, you)
  com.dice.each do |die|
    puts die.inspect
  end
  puts "Computer: #{com.yaku ? com.yaku : com.point}"
  if com.point < 2
    puts "==============="
    puts "You Win!"
  elsif com.point > 5 && com.yaku != :ARASHI
    puts "==============="
    puts "You Lost."
  else
    puts "---------------"
    you.dice.each do |die|
      puts die.inspect
    end
    puts "You:      #{you.yaku ? you.yaku : you.point}"
    puts "==============="
    if com.point == you.point
      puts "Game was drown."
    else
      if com.point < you.point
        puts "You Win!"
      else
        puts "You Lost."
      end
    end
  end
end

game.banker = computer
judge(game.play(computer), game.play(you))
