# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Choice.destroy_all

james = User.create(username:'j', email:'jamesdorr3@gmail.com', password: '1')
# eggs = Food.create(name: 'eggs', unit_size: 'large', serving_grams: 50, calories: 71.5, cholesterol: 186, dietary_fiber: 0, potassium: 69, protein: 6.28, saturated_fat: 1.56, sodium: 71, sugars: 0.19, carbs: 0.36, fat: 4.76)
# Choice.create(user: james, food: eggs, amount: 1, measure: 'unit')