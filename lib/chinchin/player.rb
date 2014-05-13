# -*- coding: utf-8 -*-

require 'chinchin/dice'

module ChinChin

  # プレイヤを表すクラス
  class Player

    # 名前を返す
    attr_reader :name

    # 現在のトークンの量を返す
    attr_reader :tokens

    # @param [String] name 名前
    # @param [Class]  result_klass 賽を投げた結果を表現するクラス
    #
    #   defaultの直接的な値はnilですが、
    #   実質的にはChinChin::Resultが定義されます
    def initialize(name, result_klass = nil)
      @name = name
      if result_klass
        @Reslut_klass = result_klass
      else
        require 'chinchin/result'
        @Reslut_klass = ChinChin::Result
      end
      @dices = [Dice.new, Dice.new, Dice.new]
      @tokens = 100
    end

    # constructで受けつけた結果クラスのインスタンスを返す
    #
    # ChinChin::Game は #cast を持つものをプレイヤクラスとみなす
    # @return 結果クラスのインスタンス
    def cast
      @Reslut_klass.new(@dices.map{|dice| dice.cast})
    end

    # トークンを増やす
    #
    # @param [Integer] increment 増分
    def increment_tokens(increment)
      @tokens += increment
    end

    # トークンを減らす
    #
    # @param [Integer] decrement 減分
    def decrement_tokens(decrement)
      @tokens -= decrement
    end
  end
end
