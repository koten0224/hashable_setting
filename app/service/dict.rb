class Dict < Hash
  include Common
  def self.define_by_hash(body, hash, parent: nil)
    hash.reduce(new(body, parent: parent)) do |h, (k, v)|
      h[k] = v
      h
    end
  end

  def self.define_by_children(body)
    body.children.reduce(new(body)) do |h, child|
      h[child.name] = child
      h
    end
  end

  def []=(key, value, _super: false)
    return super(key, value) if _super
    return if self.has_key?(key) && self[key] == value
    if self.has_key?(key)
      update_key(key, value)
    else
      define_key(key, value)
      def_meth(key)
    end
    key_check(key)
  end

  def delete_key(key)
    @delete_list << inst_get(key)
    inst_set(key, nil)
    delete(key)
  end

  def compare!(hash)
    delete_keys = keys - hash.keys
    hash.each do |k,v|
      self[k] = v
    end
    delete_keys.each do |k|
      delete_key(k)
    end
  end

  def def_meth(name)
    define_singleton_method(name) do
      self[name]
    end
    define_singleton_method("#{name}=") do |value|
      p [name, value]
      self[name]=value
    end
  end
  def save
    delete_from_list
    each do |key, value|
      save_child_and_value(key, value)
    end
    @changed = false
  end
end