# -*- coding: utf-8 -*-

module Models
  # トークン数の上限と下限を制御するクラス
  class LimitedNumberOfTokens
    attr_reader :upper_limit, :lower_limit

    def initialize(players, upper_limit, lower_limit)
      @players = players
      @upper_limit = upper_limit
      @lower_limit = lower_limit
    end

    # 何れかのプレイヤーのトークンが上限に達した
    def upper_limit_reahed?
      @players.to_a.any? { |player| player.tokens > @upper_limit }
    end

    # 何れかのプレイヤーのトークンが下限に達した
    def lower_limit_reahed?
      @players.to_a.any? { |player| player.tokens < @lower_limit }
    end
  end
end
