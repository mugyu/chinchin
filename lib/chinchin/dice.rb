#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module ChinChin
  class Dice

    def initialize()
      @pips = [1, 2, 3, 4, 5, 6]
    end

    # 投じた賽の目を返す
    #
    # @param phony イカサマ&テスト用
    # @return [Integer] 基本的には1から6までの整数をランダムに返す
    # @return phony が nil 以外の場合はそれを返す(イカサマ&テスト用)
    def thow(phony = nil)
      if phony
        @pips[phony]
      else
        @pips[rand(@pips.size)]
      end
    end
  end
end
