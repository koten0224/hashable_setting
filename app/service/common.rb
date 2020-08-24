module Common
  def self.included(base)
    base.class_eval do
      attr_reader :body
    end
  end

  CUSTOMER_CLASS = [Dict, List].freeze

  def initialize(body)
    @changed_list = []
    @delete_list = []
    @changed = false
    @body = body
  end

  def update_key(key, value)
    if self[key].class != value.class && inst_get(key).class != value.class
      delete_key(key)
      define_key(key, value)
    else
      update_value(key, value)
    end
  end

  def define_key(key, value)
    if CUSTOMER_CLASS.include? value.class
      pass_as_customer_class(key, value)
    elsif value.is_a? Setting
      set_child(key, value)
    elsif value.is_a? Hash
      set_hash(key, value)
    elsif value.is_a? Array
      set_array(key, value)
    else
      set_value(key, value)
    end
  end

  def update_value(key, value)
    if CUSTOMER_CLASS.include? value.class
      pass_as_customer_class(key, value)
    elsif value.is_a? Setting
      self[key] = value.value
    elsif value.is_a? Hash
      update_hash(key, value)
    elsif value.is_a? Array
      update_array(key, value)
    else
      update_value2(key, value)
    end
  end

  def pass_as_customer_class(key, value)
    self.[]=(key, value, _super: true)
    inst_set(key, value.body)
  end

  def update_hash(key, hash)
    self[key].compare! hash
  end

  def update_array(key, array)
    self[key].compare! array
  end

  def update_value2(key, value)
    self.[]=(key, value, _super: true)
    inst_get(key).value = value
  end

  def set_child(key, child)
    self.[]=(key, child.value, _super: true)
    inst_set(key, child)
  end

  def set_hash(key, hash)
    child = Setting.new(owner: @body, name: key, value: {})
    self.[]=(key, Dict.define_by_hash(hash, body: child), _super: true)
    inst_set(key, child)
  end

  def set_array(key, array)
    child = Setting.new(owner: @body, name: key, value: [])
    self.[]=(key, List.new(array, body: child), _super: true)
    inst_set(key, child)
  end

  def set_value(key, value)
    child = Setting.new(owner: @body, name: key, value: value)
    self.[]=(key, value, _super: true)
    inst_set(key, child)
  end

  def inst_set(name, child)
    instance_variable_set("@_#{name}", child)
  end

  def inst_get(name)
    instance_variable_get("@_#{name}")
  end
end