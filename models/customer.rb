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

  def self.map_items(array_of_customer_data_hashes)
    result = array_of_customer_data_hashes.map{|data| Customer.new(data)}
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



end
