class Screening

  def self.save(film_id,showtime)
    sql = "INSERT INTO screenings(film_id, screening_time) VALUES ($1, $2)"
    values = [film_id, showtime]
    SqlRunner.run(sql, values)
  end

  def self.display_screenings_by_film_id(film_id)
    sql = "SELECT screening_time FROM screenings WHERE film_id = $1"
    values = [film_id]
    array_of_screening_info_hashes = SqlRunner.run(sql, values)
    array_of_screening_objects = array_of_s_hash.map{|info|
    Screening.new(info)}
    return array_of_showtime_objects
  end

end
