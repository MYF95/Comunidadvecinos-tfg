User.create!(email: 'ponsan@bork.com', first_name: 'Ponsan', last_name: 'Yao', birthday: '27-06-2018', admin: true, password: 'chicken', password_confirmation: 'chicken', approved: true)
User.create!(email: 'admin@test.com', first_name: 'Admin', last_name: 'User', birthday: '27-06-2018', admin: true, password: 'chicken', password_confirmation: 'chicken', approved: true)
User.create!(email: 'tsukki@bork.com', first_name: 'Tsukki', last_name: 'Yao', birthday: '27-06-2018', admin: false, password: 'chicken', password_confirmation: 'chicken', approved: true)
User.create!(email: 'user@test.com', first_name: 'Test', last_name: 'User', birthday: '27-06-2018', admin: false, password: 'chicken', password_confirmation: 'chicken', approved: true)

Apartment.create(floor: 1, letter: 'A', fee: 60, apartment_contribution: 0.30)
Apartment.create(floor: 1, letter: 'B', fee: 50, apartment_contribution: 0.25)
Apartment.create(floor: 2, letter: 'A', fee: 60, apartment_contribution: 0.30)
Apartment.create(floor: 2, letter: 'B', fee: 30, apartment_contribution: 0.15)

UserApartment.create(user_id: 1, apartment_id: 1)
UserApartment.create(user_id: 2, apartment_id: 2)
UserApartment.create(user_id: 3, apartment_id: 3)
UserApartment.create(user_id: 4, apartment_id: 4)