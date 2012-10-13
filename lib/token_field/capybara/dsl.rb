module TokenField
  module Capybara
    module Dsl
      def fill_in_token(id, options)
        fill_in "token-input-#{input_id(id, options)}", options
        sleep(1)
        find(".token-input-dropdown-facebook li").click
      end

      def clear_token(id, options={})
        remove_buttons = page.all(:xpath, "//input[@id='#{input_id(id, options)}']/preceding-sibling::ul[@class='token-input-list-facebook'][last()]/descendant::span[@class='token-input-delete-token-facebook']")
        remove_buttons.each{ |button| button.click }
      end

      private

      def input_id(id, options)
        input_id = id
        element_id = options.delete(:element_id)
        input_id << "_#{element_id}" if element_id
        input_id
      end
    end
  end
end
