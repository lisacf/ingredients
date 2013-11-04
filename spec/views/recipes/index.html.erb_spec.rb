require 'spec_helper'

describe "recipes/index" do
  before(:each) do
    assign(:recipes, [
      stub_model(Recipe,
        :name => "Name",
        :components => "1/2 cup flour"
      ),
      stub_model(Recipe,
        :name => "Name",
        :components => "1/2 cup flour"
      )
    ])
  end

  it "renders a list of recipes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "li", :text => "Name".to_s, :count => 2
  end
end
