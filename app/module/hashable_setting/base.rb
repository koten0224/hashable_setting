module HashableSetting
  module Base  
    def save_setting(container)
      super_klass = container.class.to_s.downcase
      return if Condition.containers.exclude?(super_klass)
      container.send(Condition.send(super_klass)) do |a,b|
        condition = Condition.new(klass: super_klass, value_a: a, value_b: b)
        key, value = condition.key, condition.value
        setting = settings.find_or_initialize_by(name: key)
        sub_klass = value.class.to_s.downcase
        setting.klass, setting.value = sub_klass, value
        setting.save if setting.changes.any?
        setting.save_setting(value) if Condition.containers.include?(sub_klass)
      end
    end
  
    def load_setting
      case try(:klass)
      when 'hash', nil then settings.valid.reduce({}){ |hash,setting| hash[setting.name] = setting.load_setting; hash }
      when 'array' then settings.valid.sort_by{ |x| x.name.to_i }.reduce([]){ |array,setting| array.push(setting.load_setting) }
      else value
      end
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