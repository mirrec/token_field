# 1.1.0 (February 4, 2014)
## added
* `token_url_is_function` option for view helper to be able to use dynamic computing of url


    <%= f.token_field :parent_id, :model => :category, :token_url => "function(){ return '/hello' }", :token_url_is_function => true %>
    <%= f.token_field :parent_id, :model => :category, :token_url => "myOwnFunctionForUrl", :token_url_is_function => true %>

# 1.0.1 (October 24, 2012)
## changed
* javascript tag is generating without CDATA attribute
## fixed
* html_id element is converted with string methos parameterize and underscore, example


     old version of html_id: "order[order_items_attributes][0]_product_id"
     fixed version of html_id "order_order_items_attributes_0__product_id"

# 1.0.0 (October 14, 2012)
## changed
* set versions for developer dependencies
* removed pry from development_dependency
* removed lanchy from development_dependency

# 0.0.3 (October 14, 2012)
## fixes
* test helpers are now required automaticaly

# 0.0.2 (October 14, 2012)
## added
* support for simple_form with TokenInput class
* tests for simple_form
## changed
* readme file

# 0.0.1 (October 13, 2012)
## added
* init version of gem
* view helper token_input
* testing helper fill_in_token
* testing helper clear_token
* rspec integration tests
