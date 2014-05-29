module Models
  module Playing

    # 賭けるポイント
    DEFAULT_POINT = 5.freeze

    # 役からポイントを返す
    #
    # @param [Symble, nil] yaku 役
    # @return [integer] 役を評価して得たポイント
    def point_by(yaku)
      case yaku
      when ChinChin::Result::ARASHI
        DEFAULT_POINT * 3
      when ChinChin::Result::SHIGORO
        DEFAULT_POINT * 2
      when ChinChin::Result::HIFUMI
        DEFAULT_POINT * 2
      else
        DEFAULT_POINT
      end
    end

    # 勝負する
    #
    # @param [Game] game ChinChin::GameのInstance
    # @return [Hash] 勝負の結果
    #
    #   - キーが :bunker は親の結果
    #   - キーが :punters は子の結果の組
    def play(game)
      results = game.play
      results[:punters].each do |punter_result|
        point = point_by(results[:banker].yaku ? results[:banker].yaku : punter_result.yaku)

        case punter_result.outcome
        when ChinChin::Game::WIN
          game.banker.decrement_tokens point
          punter_result.player.increment_tokens point
        when ChinChin::Game::LOST
          game.banker.increment_tokens point
          punter_result.player.decrement_tokens point
        else
          next
        end
      end
      results
    end
  end
end
