# frozen_string_literal: true
module Kadmin
  class Select2
    class Presenter < Kadmin::Presenter
      def generate(captured, id:, **)
        return @view.render(partial: 'kadmin/components/select2', formats: 'js', locals: {
          selector: "##{id}",
          placeholder: self.placeholder,
          display_property: self.display_property,
          data_url: self.data_url,
          filter_param: self.filter_param
        }) + captured
      end
    end
  end
end
