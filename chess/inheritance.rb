require 'debugger'
class Employee

  attr_reader :salary
  attr_accessor :boss

  def initialize(name, title, salary, boss = "")
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end

end


class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
    @employees.each {|employee| employee.boss = self}
  end

  def bonus(multiplier)
    bonus = total_employee_salaries * multiplier
  end

  def total_employee_salaries
    self.employees.inject(0) {|total, employee| total + employee.salary}
  end
end

Bob = Employee.new("bob", "clerk", 10000, "")
John = Manager.new("John", "local", 50000, nil, [Bob])
