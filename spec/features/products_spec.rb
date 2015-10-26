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
    expect(page).to have_content("new one - [#{@shoes.id}, #{@skirt.id}]")
  end

  # version without javascript
  it "should be possible to add new element without javascript enabled" do
    visit new_product_path

    fill_in "product_name", :with => "hello"
    fill_in "product_category_ids", :with => "#{@pents.id}, #{@shoes.id}"
    click_button "Create Product"

    expect(page).to have_content("hello - [#{@pents.id}, #{@shoes.id}]")

    expect(Product.last.categories.map(&:id)).to eq ([@pents.id, @shoes.id])
  end

  # version with javascript
  it "should be possible to add new element with javascript enabled", :js => true do
    visit new_product_path

    fill_in "product_name", :with => "hello"
    fill_in_token "product_category_ids", :with => "shoes"
    fill_in_token "product_category_ids", :with => "pents"
    click_button "Create Product"

    expect(page).to have_content("hello")
    expect(page).to have_content("hello - [#{@shoes.id}, #{@pents.id}]")

    expect(Product.last.categories.map(&:id)).to eq([@shoes.id, @pents.id])
  end

  it "should be possible to edit element without javascript" do
    product = create(:product, :name => "product", :category_ids => [@shoes.id, @pents.id])
    expect(product.categories.map(&:id)).to eq([@shoes.id, @pents.id])

    visit edit_product_path(product)

    fill_in "product_category_ids_#{product.id}", :with => "#{@skirt.id}, #{@shoes.id}"
    click_button "Update Product"

    expect(page).to have_content("Products")

    expect(product.reload.categories.map(&:id)).to eq([@skirt.id, @shoes.id].sort)
  end

  it "should be possible to edit element with javascript enabled", :js => true do
    product = create(:product, :name => "product", :category_ids => [@shoes.id, @pents.id])
    expect(product.categories.map(&:id)).to eq([@shoes.id, @pents.id])

    visit edit_product_path(product)

    clear_token "product_category_ids_#{product.id}"
    fill_in_token "product_category_ids_#{product.id}", :with => "skirt"
    fill_in_token "product_category_ids_#{product.id}", :with => "shoes"
    click_button "Update Product"

    expect(page).to have_content("Products")

    expect(product.reload.categories.map(&:id).sort).to eq([@skirt.id, @shoes.id].sort)
  end
end