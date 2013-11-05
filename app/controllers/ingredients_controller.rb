class IngredientsController < ApplicationController
  def index
  	@ingredients = Ingredient.all.order('name ASC', 'created_at DESC')
  end

  def destroy
  	@ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to ingredients_url }
      format.json { head :no_content }
    end
  end
end
