# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

raise 'You cannot run seeds in production' if Rails.env.production?

[Task, Project, User].each do |table|
  puts "Deleting #{table.class.name} records..."
  table.delete_all
end

puts 'Starting seeding...'

puts 'Creating Users records...'
user = User.create!(email: 'dale.cooper@zéro.org', username: 'dalecooper', password: 'secret')
user.activate!

puts 'Creating Projects records...'
Project.create!([
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user, started_at: 30.days.ago, due_at: 20.days.from_now },
  { name: Faker::Company.catch_phrase.gsub(/\s/, '-'), user: user, started_at: 10.days.ago, due_at: 42.days.from_now },
])

puts 'Creating Tasks records...'
order_sequence = (1..11).to_a.shuffle
Task.create!([
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, created_at: 1.week.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, created_at: 2.weeks.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, due_at: 1.day.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, due_at: 2.days.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, created_at: 1.week.ago, due_at: 1.day.ago, started_count: 3 },
])

puts 'Seeds are now ready! You can login with: dalecooper / secret'
