# coding: UTF-8
require 'spec_helper'

describe "AutoCompleteWithDynamicUrl - Items" do
  let!(:shoes) { create(:category, :name => "shoes") }
  let!(:skirt) { create(:category, :name => "skirt") }
  let!(:pents) { create(:category, :name => "pents") }

  context "without javascript" do
    it "is possible to add new element" do
      visit new_item_path

      fill_in "item_name", :with => "hello"
      fill_in "item_category_id", :with => shoes.id
      click_button "Create Item"

      expect(page).to have_content("hello - #{shoes.id}")

      expect(Item.last.category.id).to eq(shoes.id)
    end

    it "is possible to edit element" do
      item = create(:item, :name => "item", :category_id => shoes.id)
      expect(item.category.id).to eq(shoes.id)

      visit edit_item_path(item)

      fill_in "item_category_id", :with => skirt.id
      click_button "Update Item"

      expect(item.reload.category.id).to eq(skirt.id)
    end
  end

  context "with javascript", :js => true do
    it "is possible to add new element" do
      visit new_item_path

      fill_in "item_name", :with => "hello"
      fill_in_token "item_category_id", :with => "shoes"
      click_button "Create Item"

      expect(page).to have_content("hello")
      expect(page).to have_content("hello - #{shoes.id}")

      expect(Item.last.category.id).to eq(shoes.id)
    end

    it "is possible to edit element" do
      item = create(:item, :name => "item", :category_id => shoes.id)
      expect(item.category.id).to eq(shoes.id)

      visit edit_item_path(item)

      clear_token "item_category_id"
      fill_in_token "item_category_id", :with => "skirt"

      click_button "Update Item"

      expect(page).to have_content("Items")

      expect(item.reload.category.id).to eq(skirt.id)
    end
  end
end