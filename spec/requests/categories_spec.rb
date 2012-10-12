# coding: UTF-8
require 'spec_helper'

describe "Categories" do
  before(:each) do
    @category = create(:category, :name => "wood", :parent_id => nil)
  end

  it "should list categories" do
    visit categories_path
    page.should have_content("wood - 0")
  end

  # version without javascript
  it "should be possible to add new element without javascript enabled" do
    visit new_category_path

    fill_in "category_name", :with => "hello"
    fill_in "category_parent_id", :with => @category.id.to_s
    click_button "Create Category"

    page.should have_content("wood - 0")
    page.should have_content("hello - #{@category.id}")
  end

  # version with javascript
  it "should be possible to add new element with javascript enabled", :js => true do
    visit new_category_path

    fill_in "category_name", :with => "hello"
    fill_in_token "category_parent_id", :with => "wood"
    click_button "Create Category"

    page.should have_content("wood - 0")
    page.should have_content("hello - #{@category.id}")
  end
end