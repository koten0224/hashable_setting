module HashableSetting
  module OtherModel
    include Base
    def self.included(base)        
      base.class_eval do
        has_many :settings, as: :owner, dependent: :destroy
        after_find do |resource|
          resource.settings.each do |setting|
            method_name = setting.name
            next if resource.methods.include? method_name
            define_singleton_method(method_name) do
              open_struct(setting.load_setting)
            end
          end
        end
      end
    end

    def open_struct(hash)
      hash.each do |key,value|
        if value.class == Hash
          hash[key] = open_struct(value)
        end
      end
      return OpenStruct.new hash
    end
  end
end