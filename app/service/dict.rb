class Dict < Hash
  EQ_CLASSES = [Hash, Dict].freeze
  attr_reader :changed_list, :changed, :delete_list, :name
  def initialize(owner, name=nil, **x)
    @owner = owner
    @name = name
    @changed_list = []
    @delete_list = []
    x.each do |k,v|
      self[k]=v
    end
    @changed = true
  end

  def changed?
    @changed
  end

  def ==(v)
    if EQ_CLASSES.include? v.class
      v.each do |k,v|
        return false if self[k] != v
      end
      return true
    end
  end

  def []=(k,v)
    if is_hash? v
      v = Dict.new(v)
    end
    if self[k] != v
      @changed = true
    end
    if self[k].nil?
      set_obj(k,v)
    elsif self[k] != v
      update_obj(k,v)
    end
    self.store(k,v)
  end

  def update_obj(k, v)
    if self[k].class != v
      @delete_list << get_obj(k)
      delete_obj(k)
      obj = set_obj(k,v)
    else
      obj = get_obj(k)
      obj.assign_attributes(v)
      @changed_list << obj
    end
    @changed = true
  end

  def assign_attributes(hash)
    hash.each do |k,v|
      self[k]=v
    end
  end

  def get_obj(k)
    instance_variable_get("@#{k}")
  end

  def set_obj(k,v)
    obj = generate_obj(k, v)
    instance_variable_set("@#{k}", obj)
    define_singleton_method(k) do
      self[k]
    end
    @changed = true
    @changed_list << obj
    obj
  end

  def generate_obj(k, v)
    unless is_obj?(v) || is_hash?(v)
      Setting.new(owner: @owner, name: k, value: v)
    else
      v
    end
  end

  def delete_obj(k)
    instance_variable_set("@#{k}", nil)
    self.delete(k)
  end

  def save
    return false unless @changed
    @changed_list.each do |obj|
      obj.save
    end
    @changed_list.clear
    @changed = false
    return true
  end

  def is_obj?(v)
    v.is_a? Setting
  end
  def is_hash?(v)
    v.is_a?(Hash) || v.is_a?(Dict)
  end
end