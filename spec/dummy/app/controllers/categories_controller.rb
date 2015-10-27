class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
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
    if @category.update_attributes(category_params)
      redirect_to categories_path
    else
      render :edit
    end
  end

  def token
    categories = Category.where("categories.name like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => categories.map(&:to_token) }
    end
  end

  private

  def category_params
    params.require(:category).permit!
  end
end
