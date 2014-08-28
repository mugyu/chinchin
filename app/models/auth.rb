#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Models
  # 認証
  class Auth
    def initialize(authentications)
      @authentications = {}
      authentications.each do | authentication |
        @authentications[authentication[:user]] = authentication[:password]
      end
    end

    # 認証する
    def authenticate(user, password)
      @authentications[user] == password.crypt(password)
    end
  end
end
