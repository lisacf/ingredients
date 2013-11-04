require 'spec_helper'

describe "Proportion" do 	
	subject { page }
	let(:recipe) { FactoryGirl.create :recipe }
	before do 
		visit "/recipes/#{recipe.id}"
		fill_in "Scale by:", with: 2 
		click_button "submit"
	end

	it { should have_content "1 cup flour" }

end
# 1/2 cup flour\n\r1 t baking powder