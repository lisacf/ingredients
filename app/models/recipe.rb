class Recipe < ActiveRecord::Base
  before_save :create_proportions
  has_many :proportions
  has_many :ingredients, through: :proportions
  validates_uniqueness_of :name
  validates_presence_of  :name, :components
  accepts_nested_attributes_for :proportions, :allow_destroy => true
  accepts_nested_attributes_for :ingredients

  WORD_TO_NUMBER = { 
  'a'    => 1,
  'an'  => 1,
  'pair' => 2,
  'pinch' => 0,
  'zero'  => 0,
  'one'   => 1,
  'two'   => 2,
  'three' => 3,
  'four'  => 4,
  'five'  => 5,
  'six'   => 6,
  'seven' => 7,
  'eight' => 8,
  'nine'  => 9,
  'ten'   => 10,
  'dozen' => 12
   }

   OUTLIER_MEASUREMENTS = ["drop", "drops"]
# find the number of ingredients in a components string (we don't need this method)
	def ingredient_counter
		proportion_itemizer.length
	end

#takes component string input and returns an array of line items
	def proportion_itemizer
		self.components.split("\r\n").map { |item| item.lstrip.rstrip }
	end

#takes a line item and finds and returns the amount value as a string or a nil if not present
	def amount_parser(line)
    amount_number_regex = /^\s*(\d+ \d+\/\d+|\d+\/\d+|\d+|\d+\.\d+)\s/ 
    if amount_number_regex.match(line)
      amount_number_regex.match(line).to_s.rstrip
    elsif self.amount_word_parser(line)
      self.amount_word_parser(line).to_s
    else
      0.0
		end
	end

#finds the first amount value that is a word in a line
  def amount_word_parser(line)
    array = line.split(" ")
    array.each do |word|
      if WORD_TO_NUMBER.has_key?(word)
        return word
      end
    end
    nil
  end

#sets up the hash of measurements
	def set_measurement_hash(measure, variations)
    variations.each do |abbrev|
      @unit_map[abbrev] = measure
    end
  end

#the list of all measurements and possible abbr related to measurements
  def create_unit_map
    @unit_map = {}
    # {"c." => :cup, }
    # imperial units
    set_measurement_hash :cup, ["c.", "c", "cup", "cups"]
    set_measurement_hash :fluid_ounce, ["fl. oz.", "fl oz", "fluid ounce", "fluid ounces"]
    set_measurement_hash :gallon, ["gal", "gal.", "gallon", "gallons"]
    set_measurement_hash :ounce, ["oz", "oz.", "ounce", "ounces"]
    set_measurement_hash :pint, ["pt", "pt.", "pint", "pints"]
    set_measurement_hash :pound, ["lb", "lb.", "pound", "pounds"]
    set_measurement_hash :quart, ["qt", "qt.", "qts", "qts.", "quart", "quarts"]
    set_measurement_hash :tablespoon, ["tbsp.", "tbsp", "T", "T.", "tablespoon", "tablespoons"]
    set_measurement_hash :teaspoon, ["tsp.", "tsp", "t", "t.", "teaspoon", "teaspoons"]
    # metric units
    set_measurement_hash :gram, ["g", "g.", "gr", "gr.", "gram", "grams"]
    set_measurement_hash :kilogram, ["kg", "kg.", "kilogram", "kilograms"]
    set_measurement_hash :liter, ["l", "l.", "liter", "liters"]
    set_measurement_hash :milligram, ["mg", "mg.", "milligram", "milligrams"]
    set_measurement_hash :milliliter, ["ml", "ml.", "milliliter", "milliliters"]
    # independent measures
    set_measurement_hash :pinch, ["pinch"]
    set_measurement_hash :dash, ["dash"]
    set_measurement_hash :sprig, ["sprig", "sprigs"]
    set_measurement_hash :piece, ["piece", "pieces"]
    set_measurement_hash :bag, ["bag", "bags"]
    set_measurement_hash :box, ["box", "boxes"]
    set_measurement_hash :package, ["package", "packages", "pkg.", "pkg"]
    set_measurement_hash :stick, ["stick", "sticks"]
    set_measurement_hash :drop, ["drop", "drops"]
    set_measurement_hash :slice, ["slice", "slices"]
    set_measurement_hash :splash, ["splash"]
    set_measurement_hash :can, ["can", "cans"]
    set_measurement_hash :jar, ["jar", "jars"]
    set_measurement_hash :none, ["none"]
  end



#takes a line and returns the word matching a measurement
  def find_measurement(line)
  	create_unit_map
    word_regex = /[a-zA-Z]+/
    tablespoon_regex = /(T\s|T.\s)/
    return "tablespoon" if tablespoon_regex.match(line)
		line_items = line.downcase.split(" ")
		line_items.each_with_index do |item, index|
			if @unit_map.has_key?(item)
        if OUTLIER_MEASUREMENTS.include?(item)
          word_regex.match(line_items[index - 1]) ? (return 'none'):(return item)
        else
				  return item
        end
      end
		end
    "none"
	end
  def find_comment(line)
    parenthesis_regex = /\([^\)]+\)/
    parenthesis_regex.match(line).to_s
  end

#takes a measurement string and converts it to a standardized symbol measure
  def measurement_symbol(measurement_word)
    create_unit_map
    @unit_map[measurement_word]
  end

#creates a string representing the ingredient from a line item
  def find_ingredient(line)
    line.downcase!
    line.slice!(find_measurement(line)) if find_measurement(line) != "none"
    line.slice!(amount_parser(line)) if amount_parser(line) != 0.0
    line.slice!(find_comment(line)) if find_comment(line)
    line.lstrip.rstrip
  end

#takes a mixed fraction and turns it into a float
  def mixed_fraction_to_float(fraction)
    return 0 if fraction == 0
    fraction_array = fraction.split(" ")
    if fraction_array.length == 2
      number = fraction_array.first.to_f
      proper = fraction_array.last
      total = number + proper_fraction_to_float(proper)
    elsif fraction_array.length == 1
      if fraction.include?("/")
        total = proper_fraction_to_float(fraction_array.first)
      else
        total = fraction_array.first.to_f
      end
    else
      raise "improper input to mixed_fraction_to_float method"
    end
    total
  end

#takes a proper fraction and converst to a float
  def proper_fraction_to_float(proper_fraction)
    float = proper_fraction.split('/').first.to_f/proper_fraction.split('/').last.to_f
  end



#the before save call that creates the proportions from the components
  def create_proportions
    proportion_itemizer.each do |line|
      proportion = self.proportions.build
      if amount_parser(line)
        proportion.amount = mixed_fraction_to_float(amount_parser(line))
      end
      if find_measurement(line)
        proportion.measure = measurement_symbol(find_measurement(line))
      end
      if find_comment(line)
        proportion.comment = find_comment(line)
      end
      line_ingredient = find_ingredient(line)
      db_ingredient = Ingredient.find_by_name(line_ingredient)
      if db_ingredient
        proportion.ingredient_id = db_ingredient.id
      else
        proportion.ingredient = Ingredient.create!(name: line_ingredient)
      end
      proportion.save
    end
  end


end


# method that finds words that represent amounts and picks them from a line item
# Ingredient.find_by_name(find_ingredient(line)).id else Ingredient.new(name: find_ingredient(line))
# self.proportions.build(amount:(), measure:(), ingredient: )


