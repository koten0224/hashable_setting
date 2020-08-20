class User < ApplicationRecord
  include HashableSetting::OtherModel
end
