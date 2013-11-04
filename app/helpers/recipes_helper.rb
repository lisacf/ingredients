module RecipesHelper
	def measure_render(measure, amount)
		if measure == "none"
			""
		elsif amount >= 0 and amount < 0.55
			measure
		elsif amount > 1
			measure.pluralize
		else
			measure
		end
	end


	def scale
    @scaled_proportions = @recipe.proportions

    @scaled_proportions.each do |item|
      item.amount = item.amount * @scale.to_f
    end
  end
end
