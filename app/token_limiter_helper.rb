# -*- coding: utf-8 -*-
require "models/token_limiter"

# TokenLimiter Object 生成
module TokenLimiterHelper
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_reader :token_limiter

    def make_token_limiter(players)
      @token_limiter = Models::TokenLimiter.new(players, 200, 0)
    end
  end

  # syntax suger for `self.class.tokes_limiter.upper_limit_reahed?`
  def tokens_is_upper_limit_reahed?
    self.class.token_limiter.upper_limit_reahed?
  end

  # syntax suger for `self.class.tokes_limiter.lower_limit_reahed?`
  def tokens_is_lower_limit_reahed?
    self.class.token_limiter.lower_limit_reahed?
  end
end
