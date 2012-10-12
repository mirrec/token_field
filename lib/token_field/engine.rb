module TokenField
  class Engine < ::Rails::Engine
    isolate_namespace TokenField

    initializer "token_field" do
      ActionView::Helpers::FormBuilder.instance_eval do
        include TokenField::FormBuilder
      end
    end
  end
end
