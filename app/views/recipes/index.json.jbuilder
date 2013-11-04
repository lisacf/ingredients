json.array!(@recipes) do |recipe|
  json.extract! recipe, :name, :url, :email, :username
  json.url recipe_url(recipe, format: :json)
end
