module Kadmin
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Creates a checkbox where the value is 0 when checked, 1 when unchecked.
    # @return [ActiveSupport::SafeBuffer] see Kadmin::Forms::InvertedCheckBoxTag
    def inverted_check_box(method, options = {})
      Kadmin::FormTags::InvertedCheckBox.new(@object_name, method, @template, '0', '1', objectify_options(options)).render
    end

    # Creates a Select2 enabled tag, along with the necessary Javascript
    # NOTE: Meant to be used with a Finder object in the controller
    # @return [ActiveSupport::SafeBuffer]
    def select2(method, choices, options = {}, html_options = {}, &block)
      options, html_options = Kadmin::Select2.prepare_form_tag_options(options.dup, html_options.dup)
      return ActionView::Helpers::Tags::Select.new(@object_name, method, @template, choices, options, html_options, &block).render
    end
  end
end
