module HashableSetting
  module Load
    def settings_to_hash
      body = {}
      settings.each do |setting|
        key = setting.name
        case setting.klass
        when 'hash'
          body[key] = setting.settings_to_hash
        when 'array'
          body[key] = setting.settings_to_array
        else
          body[key] = setting.display_value
        end
      end
      body
    end

    def settings_to_array
      body = []
      settings.each do |setting| setting.klass
        case setting.klass
        when 'hash'
          body << setting.settings_to_hash
        when 'array'
          body << setting.settings_to_array
        else
          body << setting.display_value
        end
      end
      body
    end
  end
end