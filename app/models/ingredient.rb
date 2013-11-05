class Ingredient < ActiveRecord::Base
	has_many :proportions
	has_many :recipes, through: :proportions
end
