class Dict < Hash
  include Common
  def self.define_by_hash(body, **hash)
    hash.reduce(new(body)) do |h, (k, v)|
      h[k] = v
      h
    end
  end

  def self.define_by_self_children(body)
    body.children.reduce(new(body)) do |h, child|
      h[child.anme] = child
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
    end
    @changed_list << inst_get(key)
    @changed = true
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

  def def_meth(name, child)
    inst_set(name, child)
    define_singleton_method(name) do
      self[name]
    end 
    define_singleton_method("#{name}=") do |value|
      self[name]=value
    end
  end
end