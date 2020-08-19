module HashableSetting
  module Save
    def save_settings_by_hash(hash)
      hash.each do |key, value|
        setting = settings.create name: key 
        if value.class == Hash
          setting.save_settings_by_hash(value)
          setting.klass = 'hash'
        elsif value.class == Array
          setting.save_settings_by_array(value)
          setting.klass = 'array'
        else
          setting.value = value
        end
        setting.save
      end
    end

    def save_settings_by_array(array)
      array.each do |value|
        setting = settings.create
        if value.class == Hash
          setting.save_settings_by_hash(value)
          setting.klass = 'hash'
        elsif value.class == Array
          setting.save_settings_by_array(value)
          setting.klass = 'array'
        else
          setting.value = value
        end
        setting.save
      end
    end
  end
end