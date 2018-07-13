require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/ticket.rb')
require_relative('models/screening.rb')
require('pry')

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({
  'name' => 'Joanna',
  'funds' => 32.50
  })
customer1.save()

customer2 = Customer.new({
  'name' => 'Bandit',
  'funds' => 12
  })
customer2.save()

film1 = Film.new({
  'title' => 'Pokemon 2',
  'price' => 7.60
  })
film1.save()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film1.id
  })
ticket2.save()

Screening.save(film1.id, '12:30')

p Screening.display_screenings_by_film_id(film1.id)


# p customer1.funds
# p film1.price
# p ticket1.film_id
# customer2.funds = 1000
# customer2.update()
# ticket1.customer_id = customer2.id
# ticket1.update()
# p customer2.films()
# p film1.customers()
# film1.delete()
# ticket1.delete()
# p Ticket.display_all()
# p Film.find(film1.id)
# p customer1.num_of_tickets()
# p film1.num_of_customers()
# p Customer.display_all()
