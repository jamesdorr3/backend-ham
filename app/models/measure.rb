class Measure < ApplicationRecord
  belongs_to :food
  has_many :choices, through: :food
  before_create :extract_numbers_from_measure_names

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
        if measure.amount
          measure.amount *= new_amount
        else
          measure.amount = new_amount
        end
        measure.name = name_split[1..].join(' ')
        measure.save
        measure.choices.select{|choice| choice.measure_id == measure.id}.each do |choice|
          if choice.amount
            choice.amount *= new_amount
          else
            choice.amount = new_amount
          end
          choice.save
        end
      end
    end
  end

  def extract_numbers_from_measure_names
    if self.name.match(/\A\d+(\/\d+)?\s/) || self.name.match(/\A\d?.\d+\s/)
      name_split = self.name.split(' ')
      new_amount = name_split[0].to_r.to_f
      self.amount *= new_amount
      self.name = name_split[1..].join(' ')
      # self.save
      # self.choices.select{|choice| choice.self_id == self.id}.each do |choice|
      #   choice.amount *= new_amount
      #   choice.save
      # end
    end
  end

end
