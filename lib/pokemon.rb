require 'pry'
class Pokemon
  attr_accessor :name, :type, :db, :id
  def initialize(name:,type:, db:,id: nil)
    @name = name
    @type = type
    @db = db
    @id = id
  end

  def self.save(name,type,db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type) 
      VALUES (?, ?)
      SQL
      db.execute(sql, name, type)
      self
  end

  def self.find(id,db)
    sql = <<-SQL
    SELECT *
    FROM pokemon
    WHERE pokemon.id = ?
    LIMIT 1
    SQL
    db.execute(sql,id).map do |row|
      @new_pokemon = Pokemon.new(name:row[1], type:row[2], db:db)
      @new_pokemon.id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end
    @new_pokemon
  end
end
