require('pry')

class Screening

  attr_reader :num_of_tickets, :screening_time
  attr_accessor :max_tickets

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @screening_time = options['screening_time']
    options['max_tickets']? @max_tickets = options['max_tickets'].to_i : @max_tickets = 50
    options['num_of_tickets']? @num_of_tickets = options['num_of_tickets'].to_i : @num_of_tickets = 0
  end

  def save()
    sql = "INSERT INTO screenings(film_id, screening_time, num_of_tickets, max_tickets) VALUES ($1, $2, $3, $4) RETURNING id"
    values = [@film_id, @screening_time, @num_of_tickets, @max_tickets]
    array_of_screening_hash = SqlRunner.run(sql, values)
    @id = array_of_screening_hash[0]['id'].to_i
  end

  def buy_ticket?()
    if @num_of_tickets+1 > @max_tickets
      return false
    else
      @num_of_tickets += 1
      update()
      return true
    end
  end

  def update()
    sql = "UPDATE screenings SET (film_id, screening_time, num_of_tickets, max_tickets) = ($1, $2, $3, $4) WHERE id = $5"
    values = [@film_id, @screening_time, @num_of_tickets, @max_tickets, @id]
    SqlRunner.run(sql, values)
  end

  def self.map_info(array_of_screening_info_hashes)
    return array_of_screening_info_hashes.map{|info| Screening.new(info)}
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    array_of_screening_info_hashes = SqlRunner.run(sql)
    return self.map_info(array_of_screening_info_hashes)
  end

  def self.all_screenings_by_film_id(film_id)
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [film_id]
    array_of_screening_info_hashes = SqlRunner.run(sql, values)
    return self.map_info(array_of_screening_info_hashes)
  end

  def self.most_popular_time_by_film_id(film_id)
    array_of_screening_objects = self.all_screenings_by_film_id(film_id)
    array_of_screening_objects.sort_by!{|screening| screening.num_of_tickets}
    return array_of_screening_objects.last.screening_time
  end

end
