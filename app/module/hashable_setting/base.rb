module HashableSetting
  module Base  
    def save_setting(container)
      container = container.to_h if container.class == OpenStruct
      super_klass = container.class.name.underscore
      return if Condition.containers.exclude?(super_klass)
      container.send(Condition.send(super_klass)) do |a,b|
        condition = Condition.new(klass: super_klass, value_a: a, value_b: b)
        key, value = condition.key, condition.value
        setting = settings.find_or_initialize_by(name: key)
        sub_klass = value.class.name.underscore
        data, value = value, nil if Condition.containers.include?(sub_klass)
        value = value.id if value.is_orm?
        setting.klass, setting.value = sub_klass, value
        setting.save if setting.changes.any?
        setting.save_setting(data) if Condition.containers.include?(sub_klass)
      end
    end
  
    def load_setting
      return @load_setting if @load_setting
      klass = try(:klass)
      if klass&.is_orm_class?
        @load_setting = klass.find_class.find(value)
      else
        @load_setting = case klass
        when 'hash', nil then settings.valid.reduce(OpenStruct.new){ |op,setting| op[setting.name] = setting.load_setting; op }
        when 'array' then settings.valid.sort_by{ |x| x.name.to_i }.reduce([]){ |array,setting| array.push(setting.load_setting) }
        else value
      end
      return @load_setting
    end
    
    class Condition
      cattr_accessor :hash, :array, :containers
      attr_accessor :key, :value
      @@hash, @@array = 'each', 'each_with_index'
      @@containers = %w(hash array).freeze
      def initialize(klass:,value_a:,value_b:)
        klass == 'hash' ? (@key, @value = value_a, value_b) : (klass == 'array' ? (@key, @value = value_b, value_a) : nil)
      end
    end
  end
end