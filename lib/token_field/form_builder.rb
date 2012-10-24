module TokenField
  module FormBuilder
    include ActionView::Helpers

    #
    # form_for helper for token input with jquery token input plugin
    # for has_many and belongs_to association
    #
    # http://railscasts.com/episodes/258-token-fields
    # http://loopj.com/jquery-tokeninput/
    #
    # helper will render standard text field input with javascript.
    # javascript will change standard input to token field input
    #
    # EXAMPLE
    #
    # class Category < ActiveRecord::Base
    #   attr_accessible :name, :parent_id, :product_ids
    #   has_many :products
    #
    #   # method for converting array of categories to array of hashes in format that token input accepts
    #   def self.token_json(items)
    #     items.map{|i| {:id => i.id, :name => i.name} }
    #   end
    # end
    #
    # class Product < ActiveRecord::Base
    #   attr_accessible :name, :category_id
    #
    #   belongs_to :category
    # end
    #
    # class CategoriesController < ApplicationController
    #
    #   # action for autocomplete
    #   def token
    #     @categories = Category.where("categories.name like ?", "%#{params[:q]}%")
    #     respond_to do |format|
    #       format.json { render :json => Category.token_json(@categories) }
    #     end
    #   end
    #
    #   # rest of the class
    # end
    #
    # then in routes add route for token ajax call
    #
    # MyApplication::Application.routes.draw do
    #   resources :categories do
    #     collection do
    #       get :token # route for token -> token_categories_path
    #     end
    #   end
    # end
    #
    # then in view we call token_field
    # token_field input will be default expects, that Category model exists
    # <%= form_for @product do |f| %>
    #   <%= f.token_field :category_id %>
    # <% end %>
    #
    # possible options:
    #
    # in case the association roles where given like this
    #
    # class Product < ActiveRecord::Base
    #    belongs_to :cat, :class_name => 'Category', :foreign_key => :cat_id
    # end
    #
    # then right model need to be specified
    #
    # <%= f.token_field :cat_id, :model => :category %>
    #
    # We can use token_input also for mapping category to products
    # we will use ActiveRecord method product_ids which be default return array of ids from association
    # <%= form_for @category do |f| %>
    #   <%= f.token_field :product_ids %>
    # <% end %>
    #
    # in model we have to change product_ids= method like this
    #
    # class Category < ActiveRecord::Base
    #   has_many :products
    #
    #   alias_method :product_ids_old=, :product_ids=
    #   def product_ids=(ids)
    #     ids = ids.split(",").map(&:to_i) if ids.is_a?(String)
    #     self.product_ids_old=ids
    #   end
    #
    #   # rest of the class...
    # end
    def token_field(attribute_name, options = {})
      association_type = @object.send(attribute_name).respond_to?(:each) ? :many : :one
      model_name = (options[:model] || attribute_name.to_s.gsub(/_ids?/, "")).to_s
      association = attribute_name.to_s.gsub(/_ids?/, "").to_sym
      model = model_name.camelize.constantize
      token_url = options[:token_url]
      append_to_id = options[:append_to_id]

      token_limit = nil
      token_limit = 1 if association_type == :one

      if token_url.nil?
        token_url = "/#{model_name.pluralize}/token.json"
      end

      id = @object.send(:id)

      html_id = "#{@object_name}_#{attribute_name.to_s}"
      if append_to_id == :id && id
        html_id << "_#{id}"
      elsif append_to_id && append_to_id != :id
        html_id << "_#{append_to_id}"
      end
      html_id = html_id.parameterize.underscore

      value = nil
      data_pre = nil
      if association_type == :one && @object.send(association)
        data_pre = model.token_json([@object.send(association)]).to_json()
        value = @object.send(association).id
      elsif association_type == :many && @object.send(association.to_s.pluralize).count > 0
        data_pre = model.token_json(@object.send(association.to_s.pluralize)).to_json()
        value = @object.send(attribute_name).join(",")
      end

      on_add = options[:on_add] ? "#{options[:on_add]}" : "false"
      on_delete = options[:on_delete] ? "#{options[:on_delete]}" : "false"

      js_content = "
        jQuery.noConflict();
        jQuery(function() {
          jQuery('##{html_id}').tokenInput('#{token_url}', {
            crossDomain: false,
            tokenLimit: #{token_limit.nil? ? "null" : token_limit.to_i},
            preventDuplicates: true,
            prePopulate: jQuery('##{attribute_name}').data('pre'),
            theme: 'facebook',
            hintText: '"+t('helpers.token_field.hint_text')+"',
            searchingText: '"+t('helpers.token_field.searching_text')+"',
            noResultsText: '"+t('helpers.token_field.no_results_text')+"',
            onAdd: "+on_add+",
            onDelete: "+on_delete+"
            });
          });
      "
      script = content_tag(:script, js_content.html_safe, :type => Mime::JS)
      text_field("#{attribute_name}", "data-pre" => data_pre, :value => value, :id => html_id) + script
    end
  end
end