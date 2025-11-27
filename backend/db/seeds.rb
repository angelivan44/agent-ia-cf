User.destroy_all
Vehicle.destroy_all
InsuranceRequest.destroy_all

users_data = [
  {
    name: "Juan",
    last_name: "Pérez",
    email: "juan.perez@example.com",
    national_id: "12345678-9",
    birth_date: Date.new(1985, 5, 15),
    owner: true
  },
  {
    name: "María",
    last_name: "González",
    email: "maria.gonzalez@example.com",
    national_id: "98765432-1",
    birth_date: Date.new(1990, 8, 22),
    owner: false
  },
  {
    name: "Carlos",
    last_name: "Rodríguez",
    email: "carlos.rodriguez@example.com",
    national_id: "11223344-5",
    birth_date: Date.new(1975, 3, 10),
    owner: false

  },
  {
    name: "Ana",
    last_name: "Martínez",
    email: "ana.martinez@example.com",
    national_id: "55667788-9",
    birth_date: Date.new(1995, 11, 5),
    owner: true

  },
  {
    name: "Luis",
    last_name: "Sánchez",
    email: "luis.sanchez@example.com",
    national_id: "99887766-5",
    birth_date: Date.new(1988, 7, 30),
    owner: true

  }
]

users = users_data.map do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.last_name = user_data[:last_name]
    user.national_id = user_data[:national_id]
    user.birth_date = user_data[:birth_date]
    user.owner = user_data[:owner]
  end
end

vehicles_data = [
  {
    user: users[0],
    plate_number: "ABC-1234",
    year: Date.new(2020, 1, 1),
    price: 150000.0,
    model: "Toyota",
    currency: "smartcars"
  },
  {
    user: users[0],
    plate_number: "XYZ-5678",
    year: Date.new(2018, 1, 1),
    price: 120000.0,
    model: "Ford",
    currency: "smartcars"
  },
  {
    user: users[1],
    plate_number: "DEF-9012",
    year: Date.new(2022, 1, 1),
    price: 200000.0,
    model: "Chevrolet",
    currency: "smartcars"
  },
  {
    user: users[2],
    plate_number: "GHI-3456",
    year: Date.new(2015, 1, 1),
    price: 80000.0,
    model: "Honda",
    currency: "smartcars"
  },
  {
    user: users[3],
    plate_number: "JKL-7890",
    year: Date.new(2019, 1, 1),
    price: 110000.0,
    model: "Mercedes",
    currency: "smartcars"
  },
  {
    user: users[4],
    plate_number: "MNO-2468",
    year: Date.new(2021, 1, 1),
    price: 180000.0,
    model: "Nissan",
    currency: "smartcars"
  }
]

vehicles = vehicles_data.map do |vehicle_data|
  Vehicle.find_or_create_by!(plate_number: vehicle_data[:plate_number]) do |vehicle|
    vehicle.user = vehicle_data[:user]
    vehicle.year = vehicle_data[:year]
    vehicle.price = vehicle_data[:price]
    vehicle.model = vehicle_data[:model]
    vehicle.currency = vehicle_data[:currency]
  end
end

insurance_requests_data = [
  {
    code: "24234",
    user: users[0],
    vehicle: vehicles[0]
  },
  {
    code: "24235",
    user: users[1],
    vehicle: vehicles[2]
  },
  {
    code: "24236",
    user: users[2],
    vehicle: vehicles[3]
  },
  {
    code: "24237",
    user: users[3],
    vehicle: vehicles[4]
  }
]

users.each do |user|
  Violation.find_or_create_by!(national_id: user.national_id) do |violation|
    violation.infractions = rand(2..30)
  end
end

insurance_requests_data.each do |request_data|
  request = InsuranceRequest.find_or_initialize_by(
    code: request_data[:code],
    user: request_data[:user],
    vehicle: request_data[:vehicle]
  )
  request.code = request_data[:code]
  request.user = request_data[:user]
  request.vehicle = request_data[:vehicle]
  request.save!
end

puts "Seeds creados exitosamente:"
puts "- #{User.count} usuarios"
puts "- #{Vehicle.count} vehículos"
puts "- #{InsuranceRequest.count} solicitudes de seguro"
