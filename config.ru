# -*- coding: utf-8 -*-
require "./app/app"

run Rack::URLMap.new(
  "/" => App
)
