# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "teacher@gmail.com", name: "Teacher", role: 0, password: "123456789")
names = ["hkhs7821", "foy2803", "s102062111", "sproutstudent"] 
names.each do |name|
  email = nil
  if name != "s102062111"
    email = name + "@gmail.com"
  else
    email = name + "@gapp.nthu.edu.tw"
  end
  password = SecureRandom.base64(60)
  confirm_code = SecureRandom.base64(60)
  User.create(
    email: email, 
    name: name, 
    role: 2, 
    password: password, 
    confirm_code: confirm_code
  )
  Dictionary.create(confirm_code: confirm_code, password: password)
end

