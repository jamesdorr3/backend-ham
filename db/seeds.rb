# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Measure.destroy_all
Choice.destroy_all
Food.destroy_all
Category.destroy_all
Day.destroy_all
Goal.destroy_all
User.destroy_all

admin = User.create(username:'admin', email:'admin@ham.com', password: 'admin')
admin_goal = Goal.create(user: admin, calories: 2900, fat: 130, carbs: 240, protein: 190, name: 'workout day')
Day.create(goal: admin_goal, name: "for users who aren't signed in")


james = User.create(username:'j', email:'jamesdorr3@gmail.com', password: '1')
goal = Goal.create(user: james, calories: 2800, fat: 144, carbs: 144, protein: 240, name: 'rest day')
Goal.create(user: james, calories: 2900, fat: 130, carbs: 240, protein: 190, name: 'workout day')
today = Day.create(goal: goal, name: 'demo day')
breakfast = Category.create(user: james, name: 'Breakfast')
lunch = Category.create(user: james, name: 'Lunch')
dinner = Category.create(user: james, name: 'Dinner')
cookies = Food.create(
  user: james,
  name: 'Sausalito Milk Chocolate Macadamia cookies', 
  brand: 'Pepperidge Farm', 
  serving_grams: 26,
  serving_unit_name: 'piece',
  serving_unit_amount: 1,
  calories: 130,
  fat: 7,
  carbs: 17,
  protein: 1,
  cholesterol: 10,
  dietary_fiber: nil,
  potassium: 60,
  saturated_fat: 3.5,
  sodium: nil,
  sugars: 10,
  unit_size: 204,
  upc: '014100077121'
)
Measure.create(food: cookies, amount: cookies.serving_unit_amount, grams: cookies.serving_grams, name: cookies.serving_unit_name)
Measure.create(food: cookies, amount: cookies.serving_grams, grams: cookies.serving_grams, name: 'grams')
sour = Food.create(
  user: james,
  name: 'Sour Punch Twists', 
  brand: 'Sour Punch', 
  serving_grams: 40,
  serving_unit_name: 'piece',
  serving_unit_amount: 4,
  calories: 150,
  fat: 0.5,
  carbs: 34,
  protein: 0,
  cholesterol: 0,
  dietary_fiber: 1,
  potassium: nil,
  saturated_fat: 0.5,
  sodium: nil,
  sugars: 18,
  unit_size: 1918,
  upc: '041364082769'
)
Measure.create(food: sour, amount: sour.serving_unit_amount, grams: sour.serving_grams, name: sour.serving_unit_name)
Measure.create(food: sour, amount: sour.serving_grams, grams: sour.serving_grams, name: 'grams')
fruit_snacks = Food.create(
  user: james,
  name: 'Fruit Snacks, Mixed Fruit', 
  brand: "Welch's", 
  serving_grams: 25.5,
  serving_unit_name: 'container',
  serving_unit_amount: 1,
  calories: 80,
  fat: 0,
  carbs: 20,
  protein: 0,
  cholesterol: nil,
  dietary_fiber: nil,
  potassium: nil,
  saturated_fat: 0,
  sodium: 10,
  sugars: 11,
  unit_size: 25.5,
  upc: '034856001751'
)
Measure.create(food: fruit_snacks, amount: fruit_snacks.serving_unit_amount, grams: fruit_snacks.serving_grams, name: fruit_snacks.serving_unit_name)
Measure.create(food: fruit_snacks, amount: fruit_snacks.serving_grams, grams: fruit_snacks.serving_grams, name: 'grams')
Choice.create(
  food: cookies,
  day: today,
  amount: 100,
  category: breakfast,
  index: 9,
  measure_id: cookies.measures.last.id
)
Choice.create(
  food: sour,
  day: today,
  amount: 100,
  category: lunch,
  index: 9,
  measure_id: sour.measures.last.id
)
Choice.create(
  food: fruit_snacks,
  day: today,
  amount: 100,
  category: dinner,
  index: 9,
  measure_id: fruit_snacks.measures.last.id
)
# eggs = Food.create(name: 'eggs', unit_size: 'large', serving_grams: 50, calories: 71.5, cholesterol: 186, dietary_fiber: 0, potassium: 69, protein: 6.28, saturated_fat: 1.56, sodium: 71, sugars: 0.19, carbs: 0.36, fat: 4.76)
# Choice.create(user: james, food: eggs, amount: 1, measure: 'unit')