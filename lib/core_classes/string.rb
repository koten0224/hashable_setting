class String
  def hello
    'This is customize methods in string: hello.'
  end

  def is_orm_class?
    Object.const_get(self.camelcase)&.superclass == ApplicationRecord
  end

  def find_class
    Object.const_get(self.camelcase)
  end
end