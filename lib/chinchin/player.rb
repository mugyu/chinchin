#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'chinchin/dice'
require 'chinchin/result'

module ChinChin
  class Player
    def initialize(reslut_klass)
      @Reslut_klass = reslut_klass
      @dices = [Dice.new, Dice.new, Dice.new]
    end

    def thow
      @Reslut_klass.new(@dices.map{|dice| dice.thow})
    end
  end
end
