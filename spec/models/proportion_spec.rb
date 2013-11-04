require 'spec_helper'

describe Proportion do
  it { should respond_to :measure }

  let(:valid_measure) { Proportion.create(measure: :stick) }
  let(:invalid_measure) { Proportion.create(measure: "sticks") }

  describe "measure constraints" do
		it "accepts a valid measure" do
			expect(valid_measure).to be_valid
		end
		it "rejects an invalid measure" do
			expect(invalid_measure).to be_invalid
		end
  end
	


end

# proportions table   amount(float) measure(symbol) ingredient_id recipe_id
# class Proportions 