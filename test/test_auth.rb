#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

app = File.expand_path("../app", File.dirname(__FILE__))
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)
require "test/unit"
require "models/auth"

# test/unit Auth
class TestAuth < Test::Unit::TestCase
  def setup
    authentications = [
      { user: "user", password: "papAq5PwY/QQM" },
      { user: "hoge", password: "piXp/zeI/Nvso" }
    ]
    @auth = Models::Auth.new(authentications)
  end

  data(
    Secure1:     [true,  "user", "password"],
    Secure2:     [true,  "hoge", "piyopiyo"],
    BadPassword: [false, "user", "pazzword"],
    BadUser:     [false, "usr",  "password"]
  )
  def test_authenticate(data)
    expectation, user, password = data
    assert_equal(expectation, @auth.authenticate(user, password))
  end
end
