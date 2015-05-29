require 'tilt'
require 'nesta/models'
module Nesta
  class Page < FileModel
    alias_method :pre_median_to_html, :to_html

    def to_html(scope = Object.new, strip_heading = false)
      html = pre_median_to_html(scope)
      html.sub!(/<h1.*?>.*?<\/h1>/, "") if strip_heading
      html
    end
  end
end
