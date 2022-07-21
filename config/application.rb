require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Reservation
  class Application < Rails::Application
    config.load_defaults 5.2

    # 日本時間
    config.time_zone = "Tokyo"

  end
end
