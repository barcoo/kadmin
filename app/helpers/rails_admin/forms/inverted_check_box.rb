module RailsAdmin
  module Forms
    class InvertedCheckBox < ActionView::Helpers::Tags::CheckBox
      # Overload how it gets the value and return the invert
      def value(*args)
        return !super
      end
    end
  end
end
