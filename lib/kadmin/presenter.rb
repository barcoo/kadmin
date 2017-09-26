module Kadmin
  # Base presenter class
  class Presenter < SimpleDelegator
    # @param [Object] object the object to present
    # @param [ActiveView::Base] view the view to present in; can be provided later on
    def initialize(object, view: nil)
      super(object)
      @view = view
    end

    # Renders the wrapped object into the given view
    # @param [ActiveView::Base] view optionally render in a different view
    # @param [Hash] options additional options passed to the render method
    # @param [Proc] block optional block to render additional stuff within the template
    # @return [Object] rendered representation of the wrapped object, typically a string
    def render(view: nil, **options, &block)
      previous_view = @view
      rendered = nil
      captured = ''

      begin
        @view = view unless view.nil?
        raise Kadmin::Presenter::NoViewContext if @view.nil?
        captured = capture(&block) if block_given?
        rendered = generate(captured, **options)
      ensure
        @view = previous_view
      end

      return rendered
    end

    # Updates the context of the presenter with the given view
    # This is mostly to provide a consistent interface between
    # Presentable and Presenter, so you don't have to check if you should
    # present something or not.
    # @param [ActiveView::Base] view render in a different view
    # @return [self] returns itself, as it is already presented
    def present(view)
      @view = view
      return self
    end

    protected

    # Generates the representation of the wrapped object.
    # Should be overloaded and implemented by a concrete class.
    def generate(captured, **)
      return "<div>#{__getobj__.inspect}#{captured}</div>".html_safe
    end

    class NoViewContext < Kadmin::Error
      def initialize(message = nil)
        message ||= 'cannot render without a view context'
        super(message)
      end
    end
  end
end
