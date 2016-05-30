# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "teacher@gmail.com", name: "Teacher", role: 0, password: "123456789")
names = ["hkhs7821", "foy2803", "s102062111", "sproutstudent"] 
current_id = 0
names.each do |name|
  email = nil
  if name != "s102062111"
    email = name + "@gmail.com"
  else
    email = name + "@gapp.nthu.edu.tw"
  end
  password = "123456789"
  confirm_code = SecureRandom.base64(60)
  
  dist = "CLang"
  if current_id % 2 == 0
    dist = "PyLang"
  end
  User.create(
    email: email, 
    name: name, 
    role: 1, 
    password: password, 
    confirm_code: confirm_code,
    district: dist
  )
  Dictionary.create(confirm_code: confirm_code, password: password)
  current_id = current_id + 1
end

