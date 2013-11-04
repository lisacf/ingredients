require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the RecipesHelper. For example:
#
# describe RecipesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
# :ingredients = "1 1/2 cups all-purpose flour
# 1 teaspoon baking powder
# 1/2 teaspoon salt
# 8 tablespoons (1 stick) unsalted butter, room temperature
# 1 cup sugar
# 3 large eggs
# 1 1/2 teaspoons pure vanilla extract
# 3/4 cup milk"

# goal :
# 1. calculate the number of ingredients in a recipe
# 2. store the ingredients in a database 
# 3. associate each amount with the individual ingredient so that you can scale the recipe.
# 4. sort the recipes by ingredient (make sure results avoid allergy ing or bring back all recipes that contain ing x)
# 5. all my application to add recipe microformats to individual ingredients.
# AUSTIN best practice when it goes into helper versus model

describe RecipesHelper do

	describe "measure_render" do
		it "should render the measure with the correct pluralization" do
			expect(helper.measure_render("cup", 1.5 )).to eq("cups")
		end
	end

end
