# coding: UTF-8
require 'spec_helper'

describe "Products" do
  before(:each) do
    @shoes = create(:category, :name => "shoes")
    @skirt = create(:category, :name => "skirt")
    @pents = create(:category, :name => "pents")
  end

  it "should list products" do
    create(:product, :name => "new one", :category_ids => [@shoes.id, @skirt.id])
    visit products_path
    page.should have_content("new one - [#{@shoes.id}, #{@skirt.id}]")
  end

  # version without javascript
  it "should be possible to add new element without javascript enabled" do
    visit new_product_path

    fill_in "product_name", :with => "hello"
    fill_in "product_category_ids", :with => "#{@pents.id}, #{@shoes.id}"
    click_button "Create Product"

    page.should have_content("hello - [#{@pents.id}, #{@shoes.id}]")

    Product.last.categories.map(&:id).should eq [@pents.id, @shoes.id]
  end

  # version with javascript
  it "should be possible to add new element with javascript enabled", :js => true do
    visit new_product_path

    fill_in "product_name", :with => "hello"
    fill_in_token "product_category_ids", :with => "shoes"
    fill_in_token "product_category_ids", :with => "pents"
    click_button "Create Product"

    page.should have_content "hello"
    page.should have_content("hello - [#{@shoes.id}, #{@pents.id}]")

    Product.last.categories.map(&:id).should eq [@shoes.id, @pents.id]
  end
end