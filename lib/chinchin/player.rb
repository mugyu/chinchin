# -*- coding: utf-8 -*-

require "chinchin/dice"

module ChinChin
  # プレイヤを表すクラス
  class Player
    # 例外クラス:
    # 名無しプレイヤーを生成しようとする場合に発生する
    class NoNamePlayerError < ArgumentError; end

    # 名前を返す
    attr_reader :name

    # @param [String] name 名前
    # @param [Class]  result_klass 賽を投げた結果を表現するクラス
    #
    #   defaultの直接的な値はnilですが、
    #   実質的にはChinChin::Resultが定義されます
    def initialize(name, result_klass = nil)
      validate_name_is_required(name)
      @name = name
      @reslut_klass =
        if result_klass
          result_klass
        else
          require "chinchin/result"
          ChinChin::Result
        end
      @dice_set = [Dice.new, Dice.new, Dice.new]
    end

    # constructで受けつけた結果クラスのインスタンスを返す
    #
    # ChinChin::Game は #cast を持つものをプレイヤクラスとみなす
    # @return 結果クラスのインスタンス
    def cast
      @reslut_klass.new(@dice_set.map { |dice| dice.cast })
    end

    # 属性の検証
    #
    # - 無名でない事
    #
    # @param name 名前
    # @raise [NoNamePlayerError]
    #   パラメータの name が空または nil の場合は
    #   例外が発生する
    def validate_name_is_required(name)
      fail NoNamePlayerError,
           "Name is required." if name.nil? || name.empty?
    end
  end
end
