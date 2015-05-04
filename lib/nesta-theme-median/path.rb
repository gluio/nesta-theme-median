require "nesta/path"
module Nesta
  class Path
    class << self
      alias_method :pre_median_themes, :themes
    end

    def self.themes(*args)
      if Nesta::Config.theme && args[0] == "median"
        File.expand_path(File.join(*args[1..-1]), File.dirname(__FILE__) + "/../..")
      else
        pre_median_themes(*args)
      end
    end
  end
end
