# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: "admin@example.com", password: "111111")

require 'faker'
10.times do |n|
  name = Gimei.kanji
  email = Faker::Internet.email
  password = 'test1234TEST'
  password_confirmation = 'test1234TEST'
  birthday = Faker::Date.between(from: '1960-01-01', to: '2000-04-30')
# start_time = Faker::Date.between(from: '2021-01-01', to: '2021-04-30') #期間を限定することもできます。
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