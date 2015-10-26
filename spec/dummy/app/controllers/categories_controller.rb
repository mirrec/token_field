class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to categories_path
    else
      render :edit
    end
  end

  def token
    @categories = Category.where("categories.name like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => Category.token_json(@categories) }
    end
  end
end
