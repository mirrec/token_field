module TokenFilling
  def fill_in_token(id, options)
    fill_in "token-input-#{id}", options
    sleep(1)
    find(".token-input-dropdown-facebook li").click()
  end
end

RSpec.configure do |config|
  config.include TokenFilling
end