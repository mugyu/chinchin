#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module ChinChin
  class Result
    HIFUMI = :HIFUMI
    SHIGORO = :SHIGORO
    ARASHI = :ARASHI
    NOTHING = :NOTHING

    def initialize(pips)
      @pips = pips
    end

    def dices
      @pips
    end

    def score
      case yaku
      when HIFUMI
        -1
      when SHIGORO
        10
      when ARASHI
        10 + _score
      else
        _score
      end
    end

    def yaku
      case @pips.sort
      when [1, 2, 3]
        HIFUMI
      when [4, 5, 6]
        SHIGORO
      when [1, 1, 1], [2, 2, 2], [3, 3, 3],
           [4, 4, 4], [5, 5, 5], [6, 6, 6]
        ARASHI
      else
        NOTHING
      end
    end

    private

    def _score
      pips = @pips.sort
      case 
      when pips[0] == pips[1]
        pips[2]
      when pips[1] == pips[2]
        pips[0]
      else
        0
      end
    end
  end
end
