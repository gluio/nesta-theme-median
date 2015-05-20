require 'redcarpet'
class HTMLWithTocRender < Redcarpet::Render::HTML
  def preprocess(document)
    @document = document
  end

  def paragraph(content)
    if ['[TOC]'].include?(content)
      toc_render = Redcarpet::Render::HTML_TOC.new(nesting_level: 2)
      parser     = Redcarpet::Markdown.new(toc_render)
      rendered = parser.render(@document)
      rendered.sub!("\A<ul>", '<ul class="toc">')
      STDOUT.puts("content: '#{rendered}'").inspect
      return rendered
    else
      ["<p>",content,"</p>"].join
    end
  end
end

module Nesta
  class Page < FileModel
    def convert_to_html(format, scope, text)
      render_options = {
        prettify: true,
        safe_links_only: true,
        with_toc_data: true
      }
      markdown_options = {
        renderer: HTMLWithTocRender.new(render_options),
        autolink: true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true,
        footnotes: true,
        highlight: true,
        no_intra_emphasis: true,
        quote: true,
        strikethrough: true,
        superscript: true,
        tables: true
      }
      text = add_p_tags_to_haml(text) if @format == :haml
      template = Tilt[format].new(nil, 1, markdown_options) { text }
      template.render(scope)
    end

    def intro_image
      return metadata('Intro Image') if metadata('Intro Image')
      if self.parent
        images = %w[
          https://dl.dropboxusercontent.com/u/2609971/cover001.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover002.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover003.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover004.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover005.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover006.jpg
          https://dl.dropboxusercontent.com/u/2609971/cover007.jpg
        ]
        images.sample
      end
    end
  end

  class App
    helpers do
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

      def author_biography(name = nil)
        name ||= @page.metadata('author')
        if name
          template = name.downcase.gsub(/\W+/, '-')
          page = Page.find_by_path("/#{template}")
          page.body
        end
      end

      def author_url(name)
        "/#{name.downcase.gsub(/\W+/, '-')}"
      end
    end
  end
end
