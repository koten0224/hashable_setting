module HashableSetting
  module SettingModel
    include Base
    def self.included(base)        
      base.class_eval do
        has_many :settings, as: :owner, dependent: :destroy
        belongs_to :owner, polymorphic: true
        @@valid_class = %w(
          string 
          integer 
          true_class 
          false_class 
          hash 
          array
          ).freeze
      
        validates :name, uniqueness: {scope: :owner}
      
        scope :valid, -> { where.not(name: [nil,'']) }
        before_create :default_klass
      end
    end
    def default_klass
      unless klass.is_orm_class? || @@valid_class.include?(klass)
        self.klass = 'string'
      end
    end
  
    def value
      return self['value'] if klass.is_orm_class?
      eval_list = {
        'string' => -> {self['value']},
        'integer' =>  -> {self['value'].to_i},
        'true_class' =>  -> {true},
        'false_class' => -> {false}
      }
      eval_list[klass]&.call
    end
    
  end
end