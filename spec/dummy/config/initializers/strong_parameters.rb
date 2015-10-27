if Rails::VERSION::MAJOR < 4
  ActiveRecord::Base.class_eval do
    include ActiveModel::ForbiddenAttributesProtection
  end
end
