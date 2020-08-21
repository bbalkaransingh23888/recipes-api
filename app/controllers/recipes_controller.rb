class RecipesController < ApplicationController
  before_action :authorized

  def index
    @recipes = Recipe.where({category: params[:category_id]})
    render json: {
        'response': "Here are all your recipes",
        :data => @recipes
    }
  end

  # This method creates new category
  def create
    #this creates a new to do object
    @one_recipe = Recipe.new(recipe_params)
    if @one_recipe.save
      #if object is saved, show it to the user
      render :json => {
          :response => 'successfully created a new recipe',
          :data => @one_recipe
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
    if(@single_recipe_update = Recipe.find_by_id(params[:id])).present?
      @single_recipe_update.update(recipe_params)
      render :json => {
          :response => 'successfully updated recipe',
          :data => @single_recipe_update
      }
    else
      render :json => {
          :response => 'update failure'
      }
    end
  end

  def destroy
    if(@delete_recipe = Recipe.find_by_id(params[:id])).present?
      @delete_recipe.destroy
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
  def recipe_params
    params.permit(:name, :ingredients, :directions, :notes, :tags, :category_id)
  end
  end
