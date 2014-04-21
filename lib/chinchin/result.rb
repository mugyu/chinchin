#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module ChinChin
  class Result
    HIFUMI = :HIFUMI
    NOTHING = :NOTHING

    def initialize(pips)
      @pips = pips
    end

    def dices
      @pips
    end

    def score
      pips = @pips.sort
      return -1 if yaku === HIFUMI
      return pips[2] if pips[0] == pips[1]
      return pips[0] if pips[1] == pips[2]
      0
    end

    def yaku
      case @pips.sort
      when [1,2,3]
        HIFUMI
      else
        NOTHING
      end
    end
  end
end
