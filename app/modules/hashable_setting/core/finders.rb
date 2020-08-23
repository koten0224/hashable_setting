module HashableSetting
  module Core
    module Finders

      private

      def find_all_settings
        return children if children
        self.children = []
        ss = self.settings
        key = "#{self.class}#{self.id}"
        owner_mapping = {key => self}
        while ss.length > 0
          ss.each do |setting|
            setting.children ||= []
            key = "#{setting.owner_type}#{setting.owner_id}"
            sub_key = "#{setting.class}#{setting.id}"
            owner_mapping[key].children.push(setting)
            owner_mapping[sub_key] = setting
          end
          ss = Setting.where(owner: ss)
        end
      end

      def find_or_new_setting(key)
        find_all_settings
        sub_set = children.find{ |s| s.name == key }
        if sub_set.nil?
          sub_set = Setting.new(owner: self, name: key)
          children << sub_set
        end
        return sub_set
      end


    end
  end
end