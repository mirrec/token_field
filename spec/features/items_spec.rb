# coding: UTF-8
require 'spec_helper'

describe "Items" do
  before(:each) do
    @shoes = create(:category, :name => "shoes")
    @skirt = create(:category, :name => "skirt")
    @pents = create(:category, :name => "pents")
  end

  it "should list items" do
    create(:item, :name => "new one", :category_id => @shoes.id)
    visit items_path
    expect(page).to have_content("new one - #{@shoes.id}")
  end

  # version without javascript
  it "should be possible to add new element without javascript enabled" do
    visit new_item_path

    fill_in "item_name", :with => "hello"
    fill_in "item_category_id", :with => @shoes.id
    click_button "Create Item"

    expect(page).to have_content("hello - #{@shoes.id}")

    expect(Item.last.category.id).to eq(@shoes.id)
  end

  # version with javascript
  it "should be possible to add new element with javascript enabled", :js => true do
    visit new_item_path

    fill_in "item_name", :with => "hello"
    fill_in_token "item_category_id", :with => "shoes"
    click_button "Create Item"

    expect(page).to have_content("hello")
    expect(page).to have_content("hello - #{@shoes.id}")

    expect(Item.last.category.id).to eq(@shoes.id)
  end

  it "should be possible to edit element without javascript" do
    item = create(:item, :name => "item", :category_id => @shoes.id)
    expect(item.category.id).to eq(@shoes.id)

    visit edit_item_path(item)

    fill_in "item_category_id", :with => @skirt.id
    click_button "Update Item"

    expect(item.reload.category.id).to eq(@skirt.id)
  end

  it "should be possible to edit element with javascript enabled", :js => true do
    item = create(:item, :name => "item", :category_id => @shoes.id)
    expect(item.category.id).to eq(@shoes.id)

    visit edit_item_path(item)

    clear_token "item_category_id"
    fill_in_token "item_category_id", :with => "skirt"

    click_button "Update Item"

    expect(page).to have_content("Items")

    expect(item.reload.category.id).to eq(@skirt.id)
  end
end