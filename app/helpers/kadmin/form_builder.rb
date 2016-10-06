module Kadmin
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Creates a checkbox where the value is 0 when checked, 1 when unchecked.
    # @see Kadmin::Forms::InvertedCheckBox
    def inverted_check_box(method, options = {})
      Kadmin::Forms::InvertedCheckBox.new(@object_name, method, @template, '0', '1', objectify_options(options)).render
    end
  end
end
