class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    boss.add_employee(self) unless boss.nil?

  end

  def bonus(multiplier)
    salary * multiplier
  end

  def total_salaries
    salary
  end
end

class Manager < Employee
  attr_accessor :peons

  def initialize(name, title, salary, boss)
    self.peons = []
    super
  end

  def add_employee(emp)
    self.peons << emp
    emp.boss = self
  end

  def bonus(multiplier)
    peon_salaries * multiplier
  end

  def total_salaries
    peon_salaries + self.salary
  end

  def peon_salaries
    peons.map { |p| p.total_salaries }.reduce(0, :+)
  end
end

ned = Manager.new 'ned', 'founder', 1000000, nil
darren = Manager.new 'darren', 'TA Manager', 78000, ned
shawna = Employee.new 'shawna', 'TA', 12000, darren
david = Employee.new 'david', 'TA', 10000, darren



p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
