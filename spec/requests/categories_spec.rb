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

  it "should be possible to add new element" do
    visit new_category_path

    fill_in "category_name", :with => "hello"
    fill_in "category_parent_id", :with => "3"
    click_button "Create Category"

    page.should have_content("wood - 0")
    page.should have_content("hello - 3")
  end
end