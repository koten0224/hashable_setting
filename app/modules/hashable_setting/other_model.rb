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
              variable_name = '@' + method_name
              instance_variable_get(variable_name) || instance_variable_set(variable_name, setting.load_setting)
            end
          end
        end
      end
    end
  end
end