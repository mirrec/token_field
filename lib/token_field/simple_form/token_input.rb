require "simple_form/inputs/base"

class TokenInput < SimpleForm::Inputs::Base
  #
  # one:
  # <%= f.input :category_id, :as => :token %>
  #
  # many:
  # <%= f.input :category_ids, :as => :token %>
  def input
    @builder.token_field(attribute_name, options)
  end
end