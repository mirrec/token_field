module TokenFieldHelper

  def self.included(base)
    ActionView::Helpers::FormBuilder.instance_eval do
      include FormBuilderMethods
    end
  end

  module FormBuilderMethods
    include ActionView::Helpers

    #
    # helper na vykreslenie token inputu, pre mapovanie belongs_to aj has_many
    #
    # http://railscasts.com/episodes/258-token-fields
    # http://loopj.com/jquery-tokeninput/
    #
    # helper vykresli standardny textovy helper, spolocne s javascriptovym kodom, ktory automaticky aktivuje field ako token input
    #
    # predpoklady
    #
    # class Category < ActiveRecord::Base
    #   has_many :products
    #
    #   # metoda, ktora sa pouziva pri tvorbe tokenov, jak na stranke upravy tak pri ajaxovom volani
    #   def self.token_json(items)
    #     items.map{|i| {:id => i.id, :name => i.name} }
    #   end
    # end
    #
    # class Product < ActiveRecord::Base
    #   belongs_to :category
    # end
    #
    # class Admin::CategoriesController < Admin::AdminController
    #
    #   # metoda na ajaxovy autocomple pre token, odpoved je cez json
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
    # MyApplication::Application.routes.draw do
    #   # mapovanie ajaxoveho ovlania token na admin controller categories
    #   # dolezite je aby tento riadok bol PRED resources :categories
    #   match "admin/categories/token.json" => 'admin/categories#token'
    # end
    #
    # vo view potom zavolame
    # zakladny token input, kde bude mozne zadat len jeden prvok z modelu Category
    # <%= form_for @product do |f| %>
    #   <%= f.token_field :category_id %>
    # <% end %>
    #
    # ine nastavenia:
    #
    # ak by bola asociacia nastavena takto
    #
    # class Product < ActiveRecord::Base
    #    belongs_to :cat, :class_name => 'Category', :foreign_key => :cat_id
    # end
    #
    # je potrebne pridat nazov asociacie, ktory sa ma pouzit, kdeze model Cat neexistuje
    # <%= f.token_field :cat_id, :model => :category %>
    #
    # Mozeme mapovat aj opacny pripad, teda cez kategoriu upravovat produkty
    # 
    # <%= form_for @category do |f| %>
    #   zaklad pre manovanie 1:N, attribut product_ids poskytuje activer_record a vracia pole integerov
    #   <%= f.token_field :product_ids %>
    # <% end %>
    #
    # v modely category je ale potrebne osetrit pripad kedy do metody product_ids sa pokusime vlozit string
    #
    # class Category < ActiveRecord::Base
    #   has_many :products # ekvivaletne je to pre pouzite has_many :through
    #
    #   alias_method :product_ids_old=, :product_ids=
    #   def product_ids=(ids)
    #     ids = ids.split(",").map(&:to_i) if ids.is_a?(String)
    #     self.product_ids_old=ids
    #   end
    #   # zbytok triedy
    # end
    def token_field(attribute_name, options = {})
      association_type = @object.send(attribute_name).respond_to?(:each) ? :many : :one
      model_name = (options[:model] || attribute_name.to_s.gsub(/_ids?/, "")).to_s
      association = attribute_name.to_s.gsub(/_ids?/, "").to_sym
      model = model_name.camelize.constantize
      token_url = options[:token_url]

      token_limit = nil
      token_limit = 1 if association_type == :one

      if token_url.nil?
        token_url = "/admin/#{model_name.pluralize}/token.json"
      end

      id = @object.send(:id)
      id ||= options[:num]

      html_id = "#{@object_name}_#{attribute_name.to_s}"
      html_id << "_#{id.to_i.to_s}" if id

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

      text_field("#{attribute_name}", "data-pre" => data_pre, :value => value, :id => html_id)+
          javascript_tag("
        jQuery.noConflict();
        jQuery(function() {
          jQuery('##{html_id}').tokenInput('#{token_url}', {
            crossDomain: false,
            tokenLimit: #{token_limit.nil? ? "null" : token_limit.to_i},
            preventDuplicates: true,
            prePopulate: jQuery('##{attribute_name}').data('pre'),
            theme: 'facebook',
            hintText: '"+t('helpers.token.hint_text')+"',
            searchingText: '"+t('helpers.token.searching_text')+"',
            noResultsText: '"+t('helpers.token.no_results_text')+"',
            onAdd: "+on_add+",
            onDelete: "+on_delete+"
            });
          });
      ")
    end

    #helper na vykreslenie tagov namiesto multichoice selectu na tagy
    #ak by sa to malo ukladat do textoveho fieldu, tak model musi mat virtualny atribut, ktory bude brat pole stringov
    def tag_field(attribute_name, options = {})
      model_name = "tags"
      token_url = options[:token_url]
      if token_url.nil?
        token_url = "/#{model_name.pluralize}/token.json"
      end

      id = @object.send(:id)

      html_id = "#{@object_name}_#{attribute_name.to_s}"
      html_name = "#{@object_name}[#{attribute_name.to_s}][]"
      tags = @object.send(attribute_name)

      html_id << "_#{id.to_i.to_s}" if id

      javascript_tag("
        jQuery(function(){
            jQuery('##{html_id}').tagit({
              triggerKeys: ['enter', 'comma', 'tab'],
              initialTags: #{tags.to_json},
              select: true,
              tagSource: function(search, showChoices) {
                var that = this;
                jQuery.ajax({
                  url: '#{token_url}',
                  data: search,
                  success: function(choices) {
                    showChoices(choices);
                  }
                });
              }
            });
        });
      ")+ content_tag(:ul, "<li>sdsf</li>", :id => html_id, :name => html_name)
    end
  end
end
