# coding: UTF-8
require 'spec_helper'

describe "ModelWithStaticTokenUrl - Categories" do
  let!(:category) { create(:category, :name => "wood", :parent_id => nil) }

  context "without javascript" do
    it "is possible to add new element" do
      visit new_category_path

      fill_in "category_name", :with => "hello"
      fill_in "category_parent_id", :with => category.id.to_s
      click_button "Create Category"

      expect(page).to have_content("wood - 0")
      expect(page).to have_content("hello - #{category.id}")

      expect(Category.last.parent.id).to eq(category.id)
    end

    it "is possible to edit element" do
      new_parent = create(:category, :parent_id => nil)
      sub_category = create(:category, :parent_id => category.id)

      expect(sub_category.parent.id).to eq(category.id)
      visit edit_category_path(sub_category)

      fill_in "category_parent_id", :with => new_parent.id.to_s
      click_button "Update Category"

      expect(sub_category.reload.parent.id).to eq(new_parent.id)
    end
  end

  context "with javascript", :js => true do
    it "is possible to add new element", :js => true do
      visit new_category_path

      fill_in "category_name", :with => "hello"
      fill_in_token "category_parent_id", :with => "wood"
      click_button "Create Category"

      expect(page).to have_content("wood - 0")
      expect(page).to have_content("hello - #{category.id}")

      expect(Category.last.parent.id).to eq(category.id)
    end


    it "is possible to edit element", :js => true do
      new_parent = create(:category, :name => "new parent", :parent_id => nil)
      sub_category = create(:category, :parent_id => category.id)

      expect(sub_category.parent.id).to eq(category.id)
      visit edit_category_path(sub_category)

      clear_token "category_parent_id"
      fill_in_token "category_parent_id", :with => "new parent"
      click_button "Update Category"

      expect(page).to have_content("Categories")

      expect(sub_category.reload.parent.id).to eq(new_parent.id)
    end
  end
end