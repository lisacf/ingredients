require 'spec_helper'

# Each recipe has a line "1 cup flour" which we consider to be a proportion of flour in the recipe.
# amount, measure, ingredient - make up a line in ingredients

describe Recipe do
	before { @recipe = Recipe.new(components: "1 1/2 cups all-purpose flour\r\n1 teaspoon baking powder\r\n1/2 teaspoon
   salt\r\n8 tablespoons unsalted butter, room temperature\r\n1 cup sugar\r\n3 large eggs\r\n1 1/2 teaspoons pure vanilla
    extract\r\n3/4 cup milk") }

  describe "#ingredient_counter" do
  	it "counts the number of ingredients in a recipe" do
			@recipe.ingredient_counter.should eq 8
  	end
  end

  describe "#proportion_itemizer" do
  	context "for a list of eight proportions" do
	  	it "should return an array with eight items" do
	  		@recipe.proportion_itemizer.length.should eq 8
	  	end
	  	it "acurately extracts out the last proportion line" do
	  		@recipe.proportion_itemizer.last.should eq "3/4 cup milk"
	  	end
  	end
  end
  
  let (:line_item) {"1 1/2 c. all-purpose flour"} 
  let (:line_item_2) { "an egg" }
  let (:line_item_3) { "dozen eggs" }
  let (:line_item_4) { "1/2 teaspoon vanilla"}
  let (:line_item_5) { "salt" }
  let (:line_item_6) { "0.5 cup lemon drops" }
  let (:line_item_7) { "30 lemon drops" }
  let (:line_item_8) { "2 drops red food coloring"}
  let (:line_item_9) { "1 CUP FLOUR" }
  let (:line_item_10) { "1 T. Baking Soda" }
  let (:line_item_11) { "1 t. baking soda" }
  let (:line_item_12) { "3 (4 ounce) cans mild whole green chiles, drained (optional)" }
  let (:line_item_13) {"chopped fresh cilantro"}

  describe "#amount_parser" do
  	it "finds the amount of each ingredient used in a recipe" do
      expect(@recipe.amount_parser(line_item)).to eq "1 1/2"
      expect(@recipe.amount_parser(line_item_2)).to eq "an"
      expect(@recipe.amount_parser(line_item_3)).to eq "dozen"
      expect(@recipe.amount_parser(line_item_4)).to eq "1/2"
      expect(@recipe.amount_parser(line_item_5)).to eq 0.0
      expect(@recipe.amount_parser(line_item_6)).to eq "0.5"
      expect(@recipe.amount_parser(line_item_12)).to eq "3"
      expect(@recipe.amount_parser(line_item_13)).to eq 0.0
  	end
  end

  describe "#amount_word_parser(line)" do
    it "finds a word that represents an amount" do
      expect(@recipe.amount_word_parser(line_item_2)).to eq "an"
    end
  end

  describe "#find_measurement" do
    it "find the unit of measure in each ingredient line of a recipe" do
      expect(@recipe.find_measurement(line_item)).to eq "c."
      expect(@recipe.find_measurement(line_item_6)).to eq "cup"
      expect(@recipe.find_measurement(line_item_7)).to eq "none"
      expect(@recipe.find_measurement(line_item_8)).to eq "drops"
      expect(@recipe.find_measurement(line_item_9)).to eq "cup"
      expect(@recipe.find_measurement(line_item_10)).to eq "tablespoon"
      expect(@recipe.find_measurement(line_item_11)).to eq "t."
      expect(@recipe.find_measurement(line_item_12)).to eq "cans"
      expect(@recipe.find_measurement(line_item_13)).to eq "none"
    end
  end

  describe "#measurement_symbol" do
    it "turns the measurment into a common measurement symbol" do
      expect(@recipe.measurement_symbol(@recipe.find_measurement(line_item))).to eq :cup
    end
  end

  describe "#find_ingredient" do
    it "isolates the ingredient component of a line in a recipe" do
      expect(@recipe.find_ingredient(line_item)).to eq "all-purpose flour"
      expect(@recipe.find_ingredient(line_item_2)).to eq "egg"
      expect(@recipe.find_ingredient(line_item_3)).to eq "eggs"
      expect(@recipe.find_ingredient(line_item_9)).to eq "flour"
      expect(@recipe.find_ingredient(line_item_10)).to eq "baking soda"
      expect(@recipe.find_ingredient(line_item_13)).to eq "chopped fresh cilantro"
    end
  end

  describe "#mixed_fraction_to_float" do
    it "converts a fraction into a float" do
      expect(@recipe.mixed_fraction_to_float("1 1/2")).to eq 1.5
    end
    it "raises error on invalid fraction" do
      expect { @recipe.mixed_fraction_to_float("1 1 1/2")}.to raise_error(RuntimeError, "improper input to mixed_fraction_to_float method")
    end

  end

  describe "#find_comment" do
    it "finds anything in parenthesis" do
      expect(@recipe.find_comment(line_item_12)).to eq "(4 ounce)"
    end
  end

  

  # describe "#create_proportions" do
  #   it "takes the components param and saves it as a series of proportions on the recipe model" do
  #     expect(@recipe.create_proportions).to eq @recipe.proportions
  #   end
  # end
end

# TODO
# range amount find and convert
# ingredient find section
# convert measurement_parser to individual line parser

#  1 to 3 lemons
# 1-3
# You will take a recipe.  Divide into line items.  Each line item will be saved into the database as a single row with a proportion id
# amount, measure, ingredient  Table proportions, amount measure ingredient recipe_id
# recipe
# recipe_hash = [{:amount => "1/2", :measure => "cup", :ingredient => "sugar"}, {}]

  # propoptions is a table  :amount ---- a floating point in database - we convert to how we want to show it 0.5 1/2 
  #             :measure --- one of 20 possiblilites
  #             :recipe_id 
  #             :ingredient_id -- this database is growing with the recipes

# recipes table  Recipe has many proportions
#   id 1 name: vanilla cake source: "", url:
# proportion table belongs to recipe, belongs to ingredient
#   id 1 recipe_id 1 amount: 1.5 measure: :cup ingredient_id: 1
# ingredients table has many proportions, has many recipes through proportions
#   id 1 name: "all-purpose flour"


