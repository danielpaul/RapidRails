# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development?
  admin = AdminUser.find_or_initialize_by(email: "admin@example.com")
  admin.password = "password"
  admin.password_confirmation = "password"
  admin.skip_confirmation! if admin.confirmed_at.blank?
  admin.save!
end
