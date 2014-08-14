# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)
require "sinatra/base"
require "sinatra/reloader"

require "players_helper"
require "token_limiter_helper"
require "game_builder"
require "game_result_helper"

require "base64"

# チンチロリン アプリケーション
class App < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, "..", "public"))

  enable :sessions

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

  helpers PlayersHelper
  helpers TokenLimiterHelper
  helpers GameBuilder
  helpers GameResultHelper

  get "/" do
    new_game
    erb :index
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    redirect "/", 303
  end

  get "/play" do
    if game.counter_limit_reached?
      erb :finish
    else
      self.result = game.play
      if tokens_is_upper_limit_reahed? ||
         tokens_is_lower_limit_reahed?
        erb :finish
      else
        erb :play, locals: { game_results: result }
      end
    end
  end

  get "/join" do
    validation_error = session[:validation_error]
    session[:validation_error] = nil
    erb :join, locals: { validation_error: validation_error }
  end

  get "/players" do
    erb :players, players: players
  end

  post "/players" do
    begin
      players.add_player(ChinChin::Player.new(params[:name]))
      redirect "/players", 303
    rescue ChinChin::Player::NoNamePlayerError
      session[:validation_error] = "Name is required."
      redirect "/join", 303
    rescue ChinChin::Players::DuplicatePlayerNameError
      session[:validation_error] = "Duplicate name."
      redirect "/join", 303
    end
    session[:validation_error] = nil
  end

  get "/remove/player/:id" do
    name = Base64.urlsafe_decode64(params[:id])
    removable_player = players.to_a.find { |player| player.name == name }
    players.remove_player removable_player if removable_player
    redirect "/players", 303
  end
end
