require 'nesta-contentfocus-extensions'
require "nesta-theme-median/version"
require "nesta-theme-median/app"

module Nesta
  module Theme
    module Median
    end
  end
end

base_path = File.expand_path("../assets", File.dirname(__FILE__))
Nesta::Theme.register(:median, { base: base_path })
