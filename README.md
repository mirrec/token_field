# TokenField

This gem add helper for form_for to Ruby on Rails 3.+
form_for helper for token input with jquery token input plugin
for has_many and belongs_to association

http://railscasts.com/episodes/258-token-fields
http://loopj.com/jquery-tokeninput/
https://github.com/foohey/jquery-tokeninput-rails

helper will render standard text field input with javascript.
javascript will change standard input to token field input

## Installation

Add this line to your application's Gemfile:

    gem "jquery-tokeninput-rails" # dependency
    gem "token_field"

And then execute:

    $ bundle

## Usage

### Javascript include

    //= require jquery.tokeninput

### Stylesheet include

    *= require token-input-facebook

### belongs_to with token_input

usage for tree

we have a model Category like this

    class Category < ActiveRecord::Base
       attr_accessible :name, :parent_id

       has_many :categories, :foreign_key => :parent_id
       belongs_to :parent, :foreign_key => :parent_id, :class_name => "Category"

       # method for converting array of categories to array of hashes in format that token input accepts
       def self.token_json(items)
         items.map{|i| {:id => i.id, :name => i.name} }
       end
    end

we have action for responding for token input ajax calls, simple autocomplete

    class CategoriesController < ApplicationController

       # action for autocomplete
       def token
         @categories = Category.where("categories.name like ?", "%#{params[:q]}%")
         respond_to do |format|
           format.json { render :json => Category.token_json(@categories) }
         end
       end

       # rest of the class
    end

in routes we have route for token ajax call

    MyApplication::Application.routes.draw do
       resources :categories do
         collection do
           get :token # route for token -> token_categories_path
         end
       end
    end

then in view we call token_field with param :model => :category

    <%= form_for @category do |f| %>
       <%= f.token_field :parent_id, :model => :category, :token_url => token_categories_path %>
    <% end %>

in case model is in namespace for example MyApp you should use :model like this

    <%= form_for @category do |f| %>
       <%= f.token_field :parent_id, :model => "MyApp::Category", :token_url => token_categories_path %>
    <% end %>

if there would be model Parent, we can omit :model parameter.
for example in Product model like this

    class Product < ActiveRecord::Base
       belongs_to :category
    end

we can use this code in view

    <%= form_for @product do |f| %>
      <%= f.token_field :category_id, :token_url => token_categories_path %>
    <% end %>

helper will allow you to enter only one element.

### has_many with token_input

We can use token_input also for mapping categories to product
we will use ActiveRecord method category_ids which be default return array of ids from association
in model we have to change category_ids= method like this

    class Product < ActiveRecord::Base
       has_many :product_has_categories
       has_many :categories, :through => :product_has_categories

       alias_method :category_ids_old=, :category_ids=
       def category_ids=(ids)
         ids = ids.split(",").map(&:to_i) if ids.is_a?(String)
         self.category_ids_old=ids
       end

       # rest of the class...
    end

in view you will use attribute category_ids. token input will expected more than one category.
so you can enter more than one category.

    <%= form_for @product do |f| %>
       <%= f.token_field :category_ids, :token_url => token_categories_path %>
    <% end %>

if you want to use multiple token inputs on page, and id of element would be the same, you can user option :append_to_id.

    <%= form_for @product do |f| %>
       <%= f.token_field :category_ids, :token_url => token_categories_path, :append_to_id => :id %>
    <% end %>

if @product.id is present and for example "3" it will use this id and generate id of html input like this "product_categories_ids_3"
if @product.id is nil id of html input will be "product_categories_ids"

other value for :append_id option will be used like this

    <%= form_for @product do |f| %>
       <%= f.token_field :category_ids, :token_url => token_categories_path, :append_to_id => 5 %>
    <% end %>

id of html input will be "product_categories_ids_5"

### SimpleForm support

if you use simple_form in your project, TokenInput field will be loaded.
you can use it in view like this

    <%= simple_form_for(@item) do |f| %>
      <%= f.input :category_id, :as => :token, :token_url => token_categories_path %>
    <% end %>

all options for token_field helper can be used in simple form helper as well.

## Testing

add support for helpers in rspec

    RSpec.configure do |config|
      config.include TokenField::Capybara::Dsl
    end

### test helpers for capybara

filling token input

    fill_in "category_parent_id", :with => new_parent.id # standard input
    fill_in_token "category_parent_id", :with => "wood"

clearing token input

    clear_token "category_parent_id"

project is covered by integration tests. using rspec, capybara and selenium
how to run test

    bundle # install dependency
    rake db:create
    rake db:migrate RAILS_ENV=test
    rspec spec/


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Licence

This project rocks and uses MIT-LICENSE.