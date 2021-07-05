class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  # Need to build this out so each student has a name and grade 
  # Also create a build-class method that creates the students table in the DB
  # Also create a method that can drop that table
  # Then create a method save, that can save the data concerning and indiviudal student object to the DB.
  # FINALLY create a method that both creates and saves an instance to the DB

  attr_accessor :name, :grade
  attr_reader :id
  @@all = []

  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil
    Student.all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        GRADE INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
      student = Student.new(name, grade)
      student.save
      student
  end


  def self.all
    @@all
  end

end
