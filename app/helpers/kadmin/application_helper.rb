# frozen_string_literal: true

module Kadmin
  module ApplicationHelper
    REDMINE_URL = 'https://redmine.offerista.com/projects/apps-services/issues/new'

    # @param [Exception] error used the error to prefill some fields
    # @return [String] URL to submit a new redmine ticket with prefilled params
    def redmine_ticket_link(error)
      issue = {
        subject: "Error in #{controller.class.name} (#{error.class.name})"
      }
      issue[:description] = <<~EOS
        Error while accessing #{request.url} (originally #{request.original_url})

        Error:
          <pre>#{error.message}</pre>

        Description:
          !!! Add a description of what you were doing, what happened, and what did you expect to happen !!!
      EOS

      return "#{REDMINE_URL}?#{{ issue: issue }.to_param}"
    end

    def select2_tag(name, option_tags = nil, options = {}, html_options = {})
      _, html_options = Kadmin::Select2.prepare_form_tag_options(options.dup, html_options.dup)
      return select_tag(name, option_tags, html_options)
    end
  end
end
