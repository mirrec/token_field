require "simple_form/inputs/base"

class TokenInput < SimpleForm::Inputs::Base
  #
  # one:
  # <%= f.input :category_id, :as => :token %>
  #
  # many:
  # <%= f.input :category_ids, :as => :token %>
  def input(wrapper_options=nil)
    if respond_to?(:merge_wrapper_options)
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options).
          merge(input_options)
    else
      merged_input_options = input_html_options.merge(input_options)
    end

    @builder.token_field(attribute_name, merged_input_options)
  end
end