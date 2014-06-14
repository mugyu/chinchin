# -*- coding: utf-8 -*-

module ChinChin
  # 正六面体ダイスを表すクラス
  class Dice
    def initialize
      @pips_set = [1, 2, 3, 4, 5, 6]
    end

    # 投じた賽の目を返す
    #
    # @param phony イカサマ&テスト用
    # @return [Integer] 基本的には1から6までの整数をランダムに返す
    # @return phony が nil 以外の場合はそれを返す(イカサマ&テスト用)
    def cast(phony = nil)
      if phony
        @pips_set[phony]
      else
        @pips_set[rand(@pips_set.size)]
      end
    end
  end
end
