# -*- coding: utf-8 -*-

module Models
  # トークン数の上限と下限を制御するクラス
  class TokenLimiter
    # 例外クラス:
    # プレイヤがtokensプロパティを持っていない
    class NotHaveTokensPlayerError < TypeError; end

    attr_reader :upper_limit, :lower_limit

    def initialize(players, upper_limit, lower_limit)
      validate_players(players.to_a)
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

    # プレイヤの集合の検証
    #
    # @param players [Array<#tokens>] プレイヤの集合
    # @return [Array<#tokens>] プレイヤの集合
    # @raise [NotPlayerError]
    def validate_players(players)
      players.each { |player| validate_player(player) }
    end

    # プレイヤの検証
    #
    # - tokens メソッドを持っている
    #
    # @param player [#tokens] プレイヤ
    # @return [#tokens] プレイヤ
    # @raise [NotPlayerError]
    def validate_player(player)
      unless player.respond_to? :tokens
        fail NotHaveTokensPlayerError,
             "This is not player object. tokens method is necessary."
      end

      player
    end
  end
end
