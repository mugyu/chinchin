# -*- coding: utf-8 -*-

require 'chinchin/dice'

module ChinChin

  class Player
    # @param [Class] reslut_klass 賽を投げた結果を表現するクラス
    def initialize(reslut_klass)
      @Reslut_klass = reslut_klass
      @dices = [Dice.new, Dice.new, Dice.new]
    end

    # newで受けれた結果クラスのインスタンスを返す
    #
    # @return newで受けれた結果クラスのインスタンス
    def cast
      @Reslut_klass.new(@dices.map{|dice| dice.cast})
    end
  end
end
