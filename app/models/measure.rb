class Measure < ApplicationRecord
  belongs_to :food
  has_many :choices, through: :food

  def self.find_or_create_and_extract_numbers(food:, amount:, grams:, name:)
    if name.match(/\A\d+(\/\d+)?\s/) || name.match(/\A\d?.\d+\s/)
      name_split = name.split(' ')
      amount = name_split[0].to_r.to_f
      name = name_split[1..].join(' ')
    end
    # byebug
    Measure.find_or_create_by(
      food: food,
      amount: amount,
      grams: grams, ### make servingSize OR self.serving_grams
      name: name,
    )
  end

  def self.extract_numbers_from_measure_names
    Measure.all.each do |measure|
      if measure.name.match(/\A\d+(\/\d+)?\s/) || measure.name.match(/\A\d?.\d+\s/)
        name_split = measure.name.split(' ')
        new_amount = name_split[0].to_r.to_f
        measure.amount *= new_amount
        measure.name = name_split[1..].join(' ')
        measure.save
        measure.choices.select{|choice| choice.measure_id == measure.id}.each do |choice|
          choice.amount *= new_amount
          choice.save
        end
      end
    end
  end

end
