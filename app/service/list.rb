class List < Array
  include Common
  def self.define_by_array(body, array)
    result = array.reduce(new(body)) do |a, v|
      a.push v
      a
    end
    result
  end

  def self.define_by_children(body)
    body.children.sort_by{|c|c.name.to_i}.reduce(new(body)) do |a, child|
      a.push child.value
    end
  end

  def []=(key, value, _super: false)
    return super(key, value) if _super
    return unless key = negative_check(key)
    return if length > key && self[key] == value
    if length > key
      update_key(key, value)
    else
      define_key(key, value)
    end
    key_check(key)
  end

  def push(v)
    key = length
    define_key(key, v)
    key_check(key)
    self
  end

  def negative_check(key)
    if key < 0
      if -key <= length
        length + key
      else
        return
      end
    else
      key
    end
  end

  def delete_key(key)
    @delete_list << inst_get(key)
    (key + 1..length - 1).each do |old_key|
      new_key = old_key - 1
      inst_set(new_key, inst_get(old_key))
    end
  end

  def compare!(array)
    delete_length = length - array.length
    array.each_with_index do |v, i|
      self[i] = v
    end
    if delete_length > 0
      start_index = length - delete_length
      end_index = length - 1
      end_index.downto(start_index).each do |key|
        delete_key(key)
        delete_at(key)
      end
    end
  end
  def save
    delete_from_list
    each_with_index do |value, index|
      save_child_and_value(index, value)
    end
    @changed = false
  end
end