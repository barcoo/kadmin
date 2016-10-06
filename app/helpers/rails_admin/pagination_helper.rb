module RailsAdmin
  module PaginationHelper
    # @param [RailsAdmin::Finder::Pager] pager context to paginate
    # @param [Array<Integer>] sizes array of page sizes
    def paginate(pager, sizes)
      return content_tag(:div, pagination_page_list(pager) + pagination_size_list(pager, sizes), class: 'btn-toolbar')
    end

    # Page Links
    # Always include:
    # => Previous page, first, last, next
    # If we're over page 10, at ... after previous link
    # If there aren't showing the last page yet, add ... before next link
    def pagination_page_list(pager)
      links = []
      window = (pager.current_page - 2)..(pager.current_page + 2)

      window = Range.new(0, window.end - window.begin) if window.begin.negative?
      window = Range.new(window.begin, pager.pages - 1) if window.end >= pager.pages

      first_link = pagination_navigate_link(pager, 0, '&laquo;')
      previous_link = pagination_navigate_link(pager, pager.current_page - 1, '&lsaquo;')
      last_link = pagination_navigate_link(pager, pager.pages - 1, '&raquo;')
      next_link = pagination_navigate_link(pager, pager.current_page + 1, '&rsaquo;')

      if pager.previous_page?(window.begin)
        links << pagination_non_link('&hellip;', 'disabled')
      end

      window.each do |number|
        links << pagination_page_link(number, pager)
      end

      if pager.next_page?(window.end)
        links << pagination_non_link('&hellip;', 'disabled')
      end

      links.unshift(first_link, previous_link)
      links << next_link
      links << last_link

      return content_tag(:div, links.reduce(&:+), class: 'btn-group')
    end
    private :pagination_page_list

    def pagination_non_link(text, css_classes = nil)
      classes = %w(btn btn-default) + Array.wrap(css_classes)
      return content_tag(:div, text.to_s.html_safe, class: classes.join(' '))
    end
    private :pagination_non_link

    def pagination_link(text, options = {}, css_classes = nil)
      classes = %w(btn btn-default) + Array.wrap(css_classes)
      return link_to(text.to_s.html_safe, params.merge(options), class: classes.join(' '))
    end
    private :pagination_link

    def pagination_page_link(page, pager)
      link = if pager.current_page?(page)
        pagination_non_link(page + 1, 'active')
      else
        pagination_link(page + 1, page_offset: pager.offset_at(page))
      end

      return link
    end
    private :pagination_page_link

    def pagination_navigate_link(pager, page, text)
      link = if pager.contains?(page)
        pagination_link(text, page_offset: pager.offset_at(page))
      else
        pagination_non_link(text, 'disabled')
      end

      return link
    end
    private :pagination_navigate_link

    # Page Sizes
    def pagination_size_list(pager, sizes)
      label = content_tag(:div, 'Per page: ', class: 'btn')
      links = sizes.map do |size|
        if pager.size == size
          pagination_non_link(size, 'active')
        else
          pagination_link(size, page_size: size)
        end
      end.reduce(&:+)

      return content_tag(:div, label + links, class: 'btn-group')
    end
    private :pagination_size_list
  end
end
