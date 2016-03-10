def datasheet_parser(file, district, role) 
    while str = file.gets
      profile = str.split(",")
      name = profile[0]
      email = profile[1]
      password = SecureRandom.base64(60)
      confirm_code = SecureRandom.base64(60)
      User.create(
        email: email, 
        name: name, 
        role: role, 
        password: password, 
        confirm_code: confirm_code,
        district: district
      )
      Dictionary.create(confirm_code: confirm_code, password: password)
    end
end

namespace :data do
  task :hsinchu =>:environment do
    filename = "C_Hsinchu.csv"
    filepath = "#{`pwd`}".split("\n")[0] + "/" + filename
    file = File.open(filepath, "r")
    datasheet_parser(file, "CLang", 2)
  end
  
  task :taipei =>:environment do
    filename = "C_Taipei.csv"
    filepath = "#{`pwd`}".split("\n")[0] + "/" + filename
    file = File.open(filepath, "r")
    datasheet_parser(file, "CLang", 2)
  end

  task :python => :environment do
    filename = "py.csv"
    filepath = "#{`pwd`}".split("\n")[0] + "/" + filename
    file = File.open(filepath, "r")
    datasheet_parser(file, "PyLang", 2)
  end
end 
