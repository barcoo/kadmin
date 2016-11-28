module Kadmin
  class Select2
    # Integrates the Select2 presenter with Rails form tag helpers/form builder
    class FormTag < ActionView::Helpers::Tags::Select
      def add_default_name_and_id(options)
        super
        @html_id = options['id']
      end

      def render
        rendered = super
        select2 = Kadmin::Select2.new(@options)

        @template_object.content_for(:javascripts) do
          @template_object.javascript_tag(select2.present(@template_object).render(id: @html_id), defer: true)
        end

        return rendered
      end
    end
  end
end
