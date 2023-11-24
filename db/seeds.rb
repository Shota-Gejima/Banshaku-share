# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#疑似的にユーザーを作成
require 'faker'
20.times do |n|
  name = Gimei.name.kanji
  email = Faker::Internet.email
  password = 'test1234TEST'
  password_confirmation = 'test1234TEST'
  birthday = Faker::Date.between(from: '1960-01-01', to: '2000-04-30')
  User.create!(
    name:                   name, 
    email:                  email,
    introduction:           "よろしくおねがいします",
    password:               password,
    password_confirmation:  password_confirmation,
    birthday:               birthday, 
    created_at:             "2023-11-9 00:00:00",
    updated_at:             "2023-11-9 00:00:00"
  )
end

#疑似的にレシピを作成
Faker::Config.locale = 'ja'
20.times do
  Recipe.create!(
    user_id: rand(1..12),
    alcohol_id: rand(1..9),
    food_id: rand(1..10),
    making_time_id: rand(1..5),
    title: Faker::Food.dish,
    description: Faker::Food.description,
    process: "お皿に盛り付けるだけです。"
  )
end