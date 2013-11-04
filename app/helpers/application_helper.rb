module ApplicationHelper
	def markdown(text)
		redcarpetmarkdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:autolink => true, :space_after_headers => true, :hard_wrap => true))
		redcarpetmarkdown.render(text).html_safe
	end

	def float_to_fraction(number)
		fraction_part = /\.\d+/	
		decimal = fraction_part.match(number.to_s)
		test = decimal.to_s
		whole_number = (number - test.to_f).round()
		fraction = test.to_f.rationalize(0.1) if test.to_f > 0
		if number == 0
			""
		elsif number < 1
			number.rationalize
		else
			whole_number >= 1  ? ("#{whole_number.to_s} #{fraction}") : (fraction)
		end
	end
end
