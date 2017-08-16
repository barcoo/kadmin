# frozen_string_literal: true

module Kadmin
  class Pager
    # Generates HTML code to present the given pager
    class Presenter < Kadmin::Presenter
      # @return [String] HTML glyph representing 'navigate to first page'
      FIRST_PAGE_SYMBOL = '&laquo;'

      # @return [String] HTML glyph representing 'navigate to previous page'
      PREVIOUS_PAGE_SYMBOL = '&lsaquo;'

      # @return [String] HTML glyph representing 'navigate to last page'
      LAST_PAGE_SYMBOL = '&raquo;'

      # @return [String] HTML glyph representing 'navigate to next page'
      NEXT_PAGE_SYMBOL = '&rsaquo;'

      # @return [String] HTML glyph used to indicate skipped page numbers
      SEPARATOR_SYMBOL = '&hellip;'

      # @return [Array<Integer>] default page size controls
      DEFAULT_SIZES = [50, 100, 500, 1000].freeze

      # Generates HTML controls to change page, and pager behaviour.
      # @param [Array<Integer>] page_sizes list of page sizes for the controls
      # @return [ActiveSupport::SafeBuffer] 'safe' HTML representing the navigation and page size controls
      def generate(captured, page_sizes: DEFAULT_SIZES, **)
        navigation = page_list
        controls = size_list(page_sizes)
        contents = navigation + controls
        contents << captured unless captured.nil?

        return "<div class='btn-toolbar'>#{contents}</div>".html_safe
      end

      def page_list
        first_link = navigate_link(0, FIRST_PAGE_SYMBOL)
        previous_link = navigate_link(self.current_page - 1, PREVIOUS_PAGE_SYMBOL)
        last_link = navigate_link(self.pages - 1, LAST_PAGE_SYMBOL)
        next_link = navigate_link(self.current_page + 1, NEXT_PAGE_SYMBOL)

        page_list_html = first_link + previous_link + page_links + next_link + last_link

        return "<div class='btn-group'>#{page_list_html}</div>"
      end
      private :page_list

      def page_links
        page_links_html = ActiveSupport::SafeBuffer.new
        page_numbers = (self.current_page - 2)..(self.current_page + 2)
        page_numbers = Range.new(0, page_numbers.end - page_numbers.begin) if page_numbers.begin.negative?
        page_numbers = Range.new(page_numbers.begin, self.pages - 1) if page_numbers.end >= self.pages

        if self.previous_page?(page_numbers.begin)
          page_links_html += list_text(SEPARATOR_SYMBOL, 'disabled')
        end

        page_numbers.each do |page_number|
          link = if self.current_page?(page_number)
            list_text(page_number + 1, css_classes: 'active')
          else
            list_link(page_number + 1, page_offset: self.offset_at(page_number))
          end

          page_links_html += link
        end

        if self.next_page?(page_numbers.end)
          page_links_html += list_text(SEPARATOR_SYMBOL, 'disabled')
        end

        return page_links_html
      end
      private :page_links

      def list_text(text, css_classes = nil)
        classes = %w[btn btn-default] + Array.wrap(css_classes)
        return "<div class='#{classes.join(' ')}'>#{text}</div>".html_safe
      end
      private :list_text

      def list_link(text, options = {})
        link_options = @view.controller.request.query_parameters.merge(options)
        return @view.link_to(text.to_s.html_safe, link_options, class: %w[btn btn-default].join(' '))
      end
      private :list_link

      def navigate_link(page_number, text)
        link = if self.current_page?(page_number) || !self.contains?(page_number)
          list_text(text, 'disabled')
        else
          list_link(text, page_offset: self.offset_at(page_number))
        end

        return link
      end
      private :navigate_link

      def size_list(sizes)
        label = "<div class='btn'>Per page: </div>"
        links = sizes.map do |size|
          if self.size == size
            list_text(size, 'active')
          else
            list_link(size, page_size: size)
          end
        end.reduce(&:+)

        return "<div class='btn-group'>#{label + links}</div>"
      end
      private :size_list
    end
  end
end
