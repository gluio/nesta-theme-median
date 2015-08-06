module Nesta
  module Theme
    module Median
      module Helpers
        def format_date(date)
          date.strftime("%d %b %Y")
        end

        def reading_time(content)
          words_per_minute = 270
          words = content.split.size
          minutes = words.to_f/words_per_minute.to_f
          if minutes < 2
            "1 min"
          else
            "#{minutes.to_i} min"
          end
        end

        def strip_html(content)
          content.gsub(/<.+?>/, " ")
        end

        def generate_summary(content)
          summary = strip_html(content).match(/(.*?\.){,2}/)[0]
          return summary if summary == content
          summary.sub(/\.\z/,"&hellip;")
        end

        def find_author_page(name)
          name ||= @page.metadata('author')
          return nil unless name
          template = name.downcase.gsub(/\W+/, '-')
          page = Page.find_by_path("/#{template}")
        end

        def author_avatar(name = nil)
          page = find_author_page(name)
          return unless page
          email = page.metadata('author email')
          if email
            hash = Digest::MD5.hexdigest(email.downcase)
            "//www.gravatar.com/avatar/#{hash}"
          end
        end

        def author_biography(name = nil)
          page = find_author_page(name)
          page.body if page
        end

        def author_full_name(name = nil)
          page = find_author_page(name)
          page.heading if page
        end

        def author_url(name)
          "/#{name.downcase.gsub(/\W+/, '-')}"
        end
      end
    end
  end
end
