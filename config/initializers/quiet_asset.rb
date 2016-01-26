#
# Mute the assets logging
# I *think* this current solution is blocking some debugging information
# so a better solution is welcomed!
# For more info: https://github.com/rails/rails/pull/3795
#

if Rails.env.development?
  Rails.application.assets.logger = Logger.new(nil)

  Rails::Rack::Logger.class_eval do
    def call_with_quiet_assets(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index("/assets/") == 0

      call_without_quiet_assets(env).tap do
        Rails.logger.level = previous_level
      end
    end

    alias_method_chain :call, :quiet_assets
  end
end