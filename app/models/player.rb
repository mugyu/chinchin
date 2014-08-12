#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "chinchin/player"

module Models
  # アプリケーション用 拡張Playerクラス
  class Player < ChinChin::Player
    # 現在のトークンの量を返す
    attr_reader :tokens

    # @see ChinChin::Players#initialize
    def initialize(name, result_klass = nil)
      super
      @tokens = 100
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
