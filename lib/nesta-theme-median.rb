require 'nesta-contentfocus-extensions'
require "nesta-theme-median/version"
require "nesta-theme-median/app"

module Nesta
  module Theme
    module Median
    end
  end
end

asset_path = File.expand_path("../assets", File.dirname(__FILE__))
view_path = File.expand_path(asset_path + "/views")
stylesheet_path = File.expand_path(asset_path + "/stylesheets")
Nesta::Theme.register(:median, { views: view_path, styles: stylesheet_path })
