module HashableSetting
  module OtherModel
    include Core::Base
    def self.included(base)
      base.extend Core::ClassMethods
      base.class_eval do
      end
    end
  end
end