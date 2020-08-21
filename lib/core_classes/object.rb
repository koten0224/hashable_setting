class Object
  def is_orm?
    self.class.superclass.name == "ApplicationRecord"
  end
end