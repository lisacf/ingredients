class Proportion < ActiveRecord::Base
	belongs_to :ingredient
	belongs_to :recipe

	validates :measure, inclusion: { in: [:cup,
																			:can,
																			:drop,
																			:splash,
																			:slice,
																			:fluid_ounce,
																			:gallon,
																			:ounce,
																			:pint,
																			:pound,
																			:quart,
																			:tablespoon,
																			:teaspoon,
																			:gram,
																			:kilogram,
																			:liter,
																			:milligram,
																			:milliliter,
																			:pinch,
																			:dash,
																			:sprig,
																			:piece,
																			:bag,
																			:box,
																			:package,
																			:stick,
																			:jar,
																			:none ] }

end