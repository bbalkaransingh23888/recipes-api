class CategoryController < ApplicationController
  before_action :authorized

  def index
    @categories = Category.all
    render json: {
        'response': "Here are all your categories",
        :data => @categories
    }
  end

  # This method creates new category
  def create
    #this creates a new to do object
    @one_category = Category.new(category_params)
    if @one_category.save
      #if object is saved, show it to the user
      render :json => {
          :response => 'successfully created a new category',
          :data => @one_category
      }
    else
      # if not, show error message
      render :json => {
          :error => 'cannot save the data'
      }
    end
  end

  def show
    # attempts to find if record exists in the table - returns boolean
    @single_category = Category.exists?(params[:id])
    #if yes, show data
    if @single_category
      render :json => {
          :response => 'successful',
          :data => Category.find(params[:id])
      }
    else
      #if no, show the error
      render :json => {
          :response => 'record not found'
      }
    end
  end

  def update
    #check if id is in the table
    if(@single_category_update = Category.find_by_id(params[:id])).present?
      @single_category_update.update(category_params)
      render :json => {
          :response => 'successfully updated recipe',
          :data => @single_category_update
      }
    else
      render :json => {
          :response => 'update failure'
      }
    end
  end

  def destroy
    if(@delete_category = Category.find_by_id(params[:id])).present?
      @delete_category.destroy
      render :json => {
          :response => 'Successfully destroyed'
      }
    else
      render :json => {
          :response => 'Nothing to destroy, shall I destroy you instead?'
      }
    end
  end

  # never trust any user inputs, we must whitelist incoming keys
  private
  def category_params
    params.permit(:title, :description, :created_by)
  end
end
