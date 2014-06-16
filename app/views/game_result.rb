# -*- coding: utf-8 -*-

module Views
  # ゲーム結果を表示
  module GameResult
    def game_result(player)
      erb :game_result, locals: {
        name: player.name,
        tokens: player.tokens
      }
    end
  end
end
