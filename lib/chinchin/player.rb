# -*- coding: utf-8 -*-

require 'chinchin/dice'

module ChinChin

  # プレイヤを表すクラス
  class Player

    # 名前を返す
    attr_reader :name

    # @param [Class] reslut_klass 賽を投げた結果を表現するクラス
    def initialize(name, reslut_klass)
      @name = name
      @Reslut_klass = reslut_klass
      @dices = [Dice.new, Dice.new, Dice.new]
    end

    # constructで受けつけた結果クラスのインスタンスを返す
    #
    # ChinChin::Game は #cast を持つものをプレイヤクラスとみなす
    # @return 結果クラスのインスタンス
    def cast
      @Reslut_klass.new(@dices.map{|dice| dice.cast})
    end
  end
end
