# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)
require "sinatra/base"
require "sinatra/reloader"

require "views/play_result"
require "game_builder"

# チンチロリン アプリケーション
class App < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, "..", "public"))

  configure :development do
    puts "Development mode."
    register Sinatra::Reloader
  end

  configure :production do
    puts "Production mode."
  end

  # 別名path
  def alias_path(path)
    call env.merge("PATH_INFO" => path)
  end

  TITLE = :ChinChin

  helpers Views::PlayResult
  helpers GameBuilder

  get "/" do
    new_game
    erb :index
  end

  get "/play" do
    if game.counter_limit_reached?
      erb :finish, locals: { players: game.players }
    else
      self.result = game.play
      if tokens_is_upper_limit_reahed? ||
         tokens_is_lower_limit_reahed?
        erb :finish, locals: { players: game.players }
      else
        erb :play, locals: { game_results: result }
      end
    end
  end

  get "/join" do
    erb :join
  end

  get "/players" do
    erb :players, players: players
  end

  post "/players" do
    players.add_player(ChinChin::Player.new(params[:name]))
    redirect "/", 303
  end
end
