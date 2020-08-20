# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.first
raise 'You need to create first user.' if u.nil?
hash = {
  data: {
    name: "Obama",
    gender: "male",
    age: 55,
    hobit: %w(guitar cat code coffee bear),
    balance: 11000000,
    status: "mad",
    address: {
      country: "Taiwan",
      city: "Taipei",
      region: "XinYi",
      Street: "DaAnRoad"
    }
  }
}
u.save_setting(hash)