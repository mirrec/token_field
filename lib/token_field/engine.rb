module TokenField
  class Engine < ::Rails::Engine
    isolate_namespace TokenField

    initializer "token_field" do
      ActionView::Helpers::FormBuilder.instance_eval do
        include TokenField::FormBuilder
      end
    end

    initializer "token_input" do
      require "token_field/simple_form/token_input" if defined?(SimpleForm)
    end
  end
end
