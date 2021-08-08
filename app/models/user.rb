class User
  attr_accessor :f_name, :l_name, :email

  def initialize attributes = {}
    @f_name = attributes[:f_name]
    @l_name = attributes[:l_name]
    @email  = attributes[:email]
  end

  def full_name2
    @f_name + " " + @l_name
  end

  def formatted_email
    full_name2 + " <#{@email}>"
  end
end
