#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module ChinChin
  class Dice
    def initialize()
      @pips = [1, 2, 3, 4, 5, 6]
    end

    def thow(phony = nil)
      if phony
        @pips[phony]
      else
        @pips[rand(@pips.size)]
      end
    end
  end
end
