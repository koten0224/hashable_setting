module Common
  def self.included(base)
    base.class_eval do
      attr_reader :body, :delete_list
      attr_accessor :parent
    end
  end

  CUSTOM_CLASS = [Dict, List].freeze

  def initialize(body, parent: nil)
    @delete_list = []
    @changed = false
    @body = body
    @parent = parent
  end

  def update_key(key, value)
    if self[key].class != value.class && inst_get(key).class != value.class
      delete_key(key)
      define_key(key, value)
    else
      update_value(key, value)
    end
    @changed = true
    @parent&.set_changed
  end

  def define_key(key, value)
    if CUSTOM_CLASS.include? value.class
      pass_as_customer_class(key, value)
      inst_set(key, value.body)
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
    if CUSTOM_CLASS.include? value.class
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
    value.parent = self
    self.[]=(key, value, _super: true)
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
    value = child.value
    self.[]=(key, value, _super: true)
    value.parent = self if CUSTOM_CLASS.include?(value.class)
    inst_set(key, child)
  end

  def set_hash(key, hash)
    child = Setting.new(owner: @body, name: key, value: {})
    self.[]=(key, Dict.define_by_hash(child, hash, parent: self), _super: true)
    inst_set(key, child)
  end

  def set_array(key, array)
    child = Setting.new(owner: @body, name: key, value: [])
    self.[]=(key, List.define_by_array(child, array, parent: self), _super: true)
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

  def changed?
    @changed
  end

  def delete_from_list
    @delete_list.each do |obj|
      obj.destroy
    end
  end

  def save_child_and_value(key, value)
    if key_value_changed?(key)
      value.save
    end
    if inst_get(key).changed?
      inst_get(key).save
    end
  end

  def key_value_changed?(key)
    CUSTOM_CLASS.include?(self[key].class) && self[key].changed?
  end

  def key_check(key)
    @changed ||= inst_get(key).changed?
    @changed ||= key_value_changed?(key)
    @parent&.set_changed if @changed
  end

  def set_changed
    @changed = true
    @parent&.set_changed
  end
end