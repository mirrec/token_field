module TokenField
  module Capybara
    module Dsl
      def fill_in_token(id, options)
        waiting = options.fetch(:waiting_call) { lambda { sleep(1) } }
        fill_in "token-input-#{input_id(id, options)}", options
        waiting.call
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
