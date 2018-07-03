User.create!(email: 'admin@test.com', first_name: 'Admin', last_name: 'User', birthday: '27-06-2018', admin: true, password: 'chicken', password_confirmation: 'chicken')
User.create!(email: 'user@test.com', first_name: 'Test', last_name: 'User', birthday: '27-06-2018', admin: false, password: 'chicken', password_confirmation: 'chicken')
User.create!(email: 'ponsan@bork.com', first_name: 'Ponsan', last_name: 'Yao', birthday: '27-06-2018', admin: true, password: 'chicken', password_confirmation: 'chicken')
User.create!(email: 'tsukki@bork.com', first_name: 'Tsukki', last_name: 'Yao', birthday: '27-06-2018', admin: false, password: 'chicken', password_confirmation: 'chicken')

Apartment.create(owner: 'Ponsan', floor: 1, letter: 'A', fee: 50, apartment_contribution: 0.15)
Apartment.create(owner: 'Admin', floor: 1, letter: 'B', fee: 50, apartment_contribution: 0.15)

UserApartment.create(user_id: 1, apartment_id: 3)
UserApartment.create(user_id: 3, apartment_id: 1)
UserApartment.create(user_id: 4, apartment_id: 1)

Statement.create(name: 'Extracto Junio 2018', date: '04-06-2018')

Movement.create(concept: 'Ingreso ponsan', date: '27-06-2018', amount: '50', description: 'Ingreso Cuota vivienda 1ºA')
Movement.create(concept: 'Ingreso ponsan 2', date: '17-06-2018', amount: '150', description: 'Ingreso Cuota vivienda 1ºA')
Movement.create(concept: 'Ingreso admin', date: '15-06-2018', amount: '50', description: 'Ingreso Cuota vivienda 1ºB')
Movement.create(concept: 'Ingreso admin', date: '05-06-2018', amount: '103', description: 'Ingreso Cuota vivienda 1ºB')

StatementMovement.create(statement_id: 1, movement_id: 1)
StatementMovement.create(statement_id: 1, movement_id: 2)
StatementMovement.create(statement_id: 1, movement_id: 3)
StatementMovement.create(statement_id: 1, movement_id: 4)

PendingPayment.create(concept: 'Cuota vivienda 1ºA', date: '01-06-2018', amount: '50', description: 'Cuota correspondiente a la vivienda 1ºA')
PendingPayment.create(concept: 'Cuota vivienda 1ºB', date: '01-06-2018', amount: '50', description: 'Cuota correspondiente a la vivienda 1ºB')