require "simple_form/inputs/base"

class TokenInput < SimpleForm::Inputs::Base
  #
  # one:
  # <%= f.input :category_id, :as => :token %>
  #
  # many:
  # <%= f.input :category_ids, :as => :token %>
  def input(wrapper_options=nil)
    merged_input_options = input_options.merge(
        merge_wrapper_options(input_html_options, wrapper_options)
    )

    @builder.token_field(attribute_name, merged_input_options)
  end
end