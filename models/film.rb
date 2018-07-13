require_relative('../db/sql_runner.rb')
require('pry')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_f
  end

  def save()
    sql = "INSERT INTO films(title, price) VALUES ($1, $2) RETURNING id"
    values = [@title,@price]
    array_of_id_hash = SqlRunner.run(sql, values)
    @id = array_of_id_hash[0]['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    array_of_film_hash = SqlRunner.run(sql, values)
    return Film.new(array_of_film_hash[0])
  end

  def self.map_items(array_of_film_info_hashes)
    return array_of_film_info_hashes.map{|info| Film.new(info)}
  end

  def self.display_all()
    sql = "SELECT * FROM films"
    array_of_film_info_hashes = SqlRunner.run(sql)
    return self.map_items(array_of_film_info_hashes)
  end

  def self.delete_all()
    sql = "DELETE from films"
    SqlRunner.run(sql)
  end

  def customers()
    sql = "SELECT customers.*
    FROM customers INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE film_id = $1"
    values = [@id]
    array_of_film_hashes = SqlRunner.run(sql, values)
    return Customer.map_items(array_of_film_hashes)
  end

  def num_of_customers()
    return customers().length
  end


end
