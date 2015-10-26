# coding: UTF-8
require 'spec_helper'

describe "Categories" do
  before(:each) do
    @category = create(:category, :name => "wood", :parent_id => nil)
  end

  it "should list categories" do
    visit categories_path
    expect(page).to have_content("wood - 0")
  end

  # version without javascript
  it "should be possible to add new element without javascript enabled" do
    visit new_category_path

    fill_in "category_name", :with => "hello"
    fill_in "category_parent_id", :with => @category.id.to_s
    click_button "Create Category"

    expect(page).to have_content("wood - 0")
    expect(page).to have_content("hello - #{@category.id}")

    expect(Category.last.parent.id).to eq(@category.id)
  end

  # version with javascript
  it "should be possible to add new element with javascript enabled", :js => true do
    visit new_category_path

    fill_in "category_name", :with => "hello"
    fill_in_token "category_parent_id", :with => "wood"
    click_button "Create Category"

    expect(page).to have_content("wood - 0")
    expect(page).to have_content("hello - #{@category.id}")

    expect(Category.last.parent.id).to eq(@category.id)
  end

  it "should be possible to edit element without javascript" do
    new_parent = create(:category, :parent_id => nil)
    category = create(:category, :parent_id => @category.id)

    expect(category.parent.id).to eq(@category.id)
    visit edit_category_path(category)

    fill_in "category_parent_id", :with => new_parent.id.to_s
    click_button "Update Category"

    expect(category.reload.parent.id).to eq(new_parent.id)
  end

  it "should be possible to edit element with javascript enabled", :js => true do
    new_parent = create(:category, :name => "new parent", :parent_id => nil)
    category = create(:category, :parent_id => @category.id)

    expect(category.parent.id).to eq(@category.id)
    visit edit_category_path(category)

    clear_token "category_parent_id"
    fill_in_token "category_parent_id", :with => "new parent"
    click_button "Update Category"

    expect(page).to have_content("Categories")

    expect(category.reload.parent.id).to eq(new_parent.id)
  end
end