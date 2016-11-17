module Kadmin
  module Pagination
    class Presenter < SimpleDelegator
      def present(view_context, sizes)
        page_links = page_list(view_context)
        size_links = size_list(view_context, sizes)

        return "<div class='btn-toolbar'>#{page_links + size_links}</div>".html_safe
      end

      # @return [Integer] the current number of items displayed for this page
      def displayed_items
        return page_end - self.offset
      end

      # @return [Integer] the index number of the last item for this page
      def page_end
        return [next_page_offset, self.total].min
      end

      # @return [Integer] the index number of the start item for this page
      def page_start
        return self.offset + 1
      end

      def next_page_offset
        return self.offset_at(self.current_page + 1)
      end

      def page_list(view_context)
        links = []
        window = page_window

        first_link = navigate_link(view_context, 0, '&laquo;')
        previous_link = navigate_link(view_context, self.current_page - 1, '&lsaquo;')
        last_link = navigate_link(view_context, self.pages - 1, '&raquo;')
        next_link = navigate_link(view_context, self.current_page + 1, '&rsaquo;')

        if self.previous_page?(window.begin)
          links << list_text('&hellip;', 'disabled')
        end

        window.each do |number|
          links << page_link(view_context, number)
        end

        if self.next_page?(window.end)
          links << list_text('&hellip;', 'disabled')
        end

        links.unshift(first_link, previous_link)
        links << next_link
        links << last_link

        return "<div class='btn-group'>#{links.reduce(&:+)}</div>".html_safe
      end
      private :page_list

      def page_window
        window = (current_page - 2)..(current_page + 2)
        window = Range.new(0, window.end - window.begin) if window.begin.negative?
        window = Range.new(window.begin, pages - 1) if window.end >= pages

        return window
      end
      private :page_window

      def list_text(text, css_classes = nil)
        classes = %w(btn btn-default) + Array.wrap(css_classes)
        return "<div class='#{classes.join(' ')}'>#{text}</div>".html_safe
      end
      private :list_text

      def list_link(view_context, text, options = {}, css_classes = nil)
        classes = %w(btn btn-default) + Array.wrap(css_classes)
        link_options = view_context.controller.request.query_parameters.merge(options)
        return view_context.link_to(text.to_s.html_safe, link_options, class: classes.join(' '))
      end
      private :list_link

      def page_link(page)
        link = if self.current_page?(page)
          list_text(page + 1, 'active')
        else
          list_link(page + 1, page_offset: self.offset_at(page))
        end

        return link
      end
      private :page_link

      def navigate_link(view_context, page, text)
        link = if self.contains?(page)
          list_link(view_context, text, page_offset: self.offset_at(page))
        else
          list_text(text, 'disabled')
        end

        return link
      end
      private :navigate_link

      def size_list(view_context, sizes)
        label = "<div class='btn'>Per page: </div>"
        links = sizes.map do |size|
          if self.size == size
            list_text(size, 'active')
          else
            list_link(view_context, size, page_size: size)
          end
        end.reduce(&:+)

        return "<div class='btn-group'>#{label + links}</div>".html_safe
      end
      private :size_list
    end
  end
end
