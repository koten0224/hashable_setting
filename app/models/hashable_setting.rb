module HashableSetting
  def self.included(base)
    base.class_eval do
      has_many :settings, as: :owner
    end
  end

  include Save
  include Load
end