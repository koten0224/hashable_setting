require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FakeMongo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoload_paths += %W(#{config.root}/lib)
    Dir[
      File.join('lib/core_classes', "*.rb"),
      File.join('lib/methods', "*.rb")
    ].each do |file|
      file.sub!(/.+?\//,'')
      require file
    end
    if ["development", "test"].include? Rails.env
      config.factory_bot.definition_file_paths = ["spec/factories"]
      config.generators do |g|
        g.factory_bot dir: 'spec/factories'
      end
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
