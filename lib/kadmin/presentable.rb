# frozen_string_literal: true

module Kadmin
  module Presentable
    extend ActiveSupport::Concern

    module ClassMethods
      def presenter_class
        return @presenter_class ||= begin
          self::Presenter
        rescue NameError
          nil
        end
      end

      def presenter_class=(klass)
        @presenter_class = klass
      end
    end

    # Delegates present to a newly instantiated presenter object
    # Checks the including class' presenter_class attribute, with fallback to an inner Presenter class
    # @param [ActiveView::Base] view the view to present in if available; can be supplied to the presenter later
    # @raise [Kadmin::Error] raises an error if no presenter class defined
    def present(view = nil)
      if self.class.presenter_class.nil?
        raise Kadmin::Error, 'cannot present without a presenter_class'
      else
        return self.class.presenter_class.new(self, view: view)
      end
    end
  end
end
