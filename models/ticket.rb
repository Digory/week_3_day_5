require_relative('../db/sql_runner.rb')
require_relative('customer.rb')
require('pry')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id =  options['film_id'].to_i
    customer = Customer.find(@customer_id)
    cost_of_film = Film.find(film_id).price
    customer.funds -= cost_of_film
    customer.update()
  end

  def save()
    sql = "INSERT INTO tickets(customer_id, film_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    array_of_id_hash = SqlRunner.run(sql, values)
    @id = array_of_id_hash[0]['id'].to_i
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(array_of_ticket_info_hashes)
    return array_of_ticket_info_hashes.map{|info| Ticket.new(info)}
  end

  def self.display_all()
    sql = "SELECT * FROM tickets"
    array_of_ticket_info_hashes = SqlRunner.run(sql)
    return self.map_items(array_of_ticket_info_hashes)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end



end
