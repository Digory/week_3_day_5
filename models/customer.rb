require_relative('../db/sql_runner.rb')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_f
  end

  def save()
    sql = "INSERT INTO customers(name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name,@funds]
    array_of_id_hash = SqlRunner.run(sql, values)
    @id = array_of_id_hash[0]['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(array_of_data_hashes)
    result = array_of_data_hashes.map{|data| Customer.new(data)}
    return result
  end

  def self.display_all()
    sql = "SELECT * FROM customers"
    array_of_customer_data_hashes = SqlRunner.run(sql)
    return self.map_items(array_of_customer_data_hashes)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    array_of_customer_hash = SqlRunner.run(sql, values)
    return Customer.new(array_of_customer_hash[0])
  end

  def films()
    sql = "SELECT films.*
    FROM films INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE customer_id = $1"
    values = [@id]
    array_of_film_hashes = SqlRunner.run(sql, values)
    return Film.map_items(array_of_film_hashes)
  end

  def num_of_tickets()
    return films().length
  end





end
