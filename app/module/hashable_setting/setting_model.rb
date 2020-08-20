module HashableSetting
  module SettingModel
    include Base
    def self.included(base)        
      base.class_eval do
        has_many :settings, as: :owner, dependent: :destroy
        belongs_to :owner, polymorphic: true
        @@valid_class = %w(string integer boolean hash array).freeze
        @@boolean_class = %w(trueclass falseclass).freeze
      
        validates :name, uniqueness: {scope: :owner}
      
        scope :valid, -> { where.not(name: [nil,'']) }
        before_create :default_klass
      end
    end
    def default_klass
      if @@boolean_class.include? klass
        self.klass = 'boolean'
      elsif @@valid_class.exclude? klass
        self.klass = 'string'
      end
    end
  
    def value
      eval_list = {
        'string' => -> {self['value']},
        'integer' =>  -> {self['value'].to_i},
        'boolean' =>  -> {self['value'] == 'true'}
      }
      eval_list[klass].call
    end
    
  end
end