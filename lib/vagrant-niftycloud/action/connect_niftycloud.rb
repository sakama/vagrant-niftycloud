require "fog"
require "log4r"

module VagrantPlugins
  module NiftyCloud
    module Action
      # This action connects to NiftyCloud, verifies credentials work, and
      # puts the NiftyCloud connection object into the `:niftycloud_compute` key
      # in the environment.
      class ConnectNiftyCloud
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_niftycloud::action::connect_niftycloud")
        end

        def call(env)
          # Get the region we're going to booting up in
          region = env[:machine].provider_config.region

          # Get the configs
          region_config     = env[:machine].provider_config.get_region_config(region)

          # Build the fog config
          fog_config = {
            :provider              => :niftycloud,
            :region                => region
          }
          if region_config.use_iam_profile
            fog_config[:use_iam_profile] = true
          else
            fog_config[:niftycloud_access_key_id] = region_config.access_key_id
            fog_config[:niftycloud_secret_access_key] = region_config.secret_access_key
          end

          fog_config[:endpoint] = region_config.endpoint if region_config.endpoint
          fog_config[:version]  = region_config.version if region_config.version

          @logger.info("Connecting to NiftyCloud...")
          env[:niftycloud_compute] = Fog::Compute.new(fog_config)

          @app.call(env)
        end
      end
    end
  end
end
