##!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'chinchin/game'
require 'chinchin/player'
require 'chinchin/result'

computer = ChinChin::Player.new(ChinChin::Result)
you = ChinChin::Player.new(ChinChin::Result)
game = ChinChin::Game.new(computer, you)

def judge(com_yaku, com_point, com_dice, you_yaku, you_point, you_dice)
  com_dice.each do |die|
    puts die.inspect
  end
  puts "Computer: #{com_yaku ? com_yaku : com_point}"
  if com_point < 2
    puts "==============="
    puts "You Win!"
  elsif com_point > 5 && com_yaku != :ARASHI
    puts "==============="
    puts "You Lost."
  else
    puts "---------------"
    you_dice.each do |die|
      puts die.inspect
    end
    puts "You:      #{you_yaku ? you_yaku : you_point}"
    puts "==============="
    if com_point == you_point
      puts "Game was drown."
    else
      if com_point < you_point
        puts "You Win!"
      else
        puts "You Lost."
      end
    end
  end
end

game.banker = computer
com_yaku, com_point, com_dice = game.play(computer)
you_yaku, you_point, you_dice = game.play(you)
judge(com_yaku, com_point, com_dice, you_yaku, you_point, you_dice)
