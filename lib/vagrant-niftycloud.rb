require "pathname"

require "vagrant-niftycloud/plugin"

module VagrantPlugins
  module NiftyCloud
    lib_path = Pathname.new(File.expand_path("../vagrant-niftycloud", __FILE__))
    autoload :Action, lib_path.join("action")
    autoload :Servers, lib_path.join("servers/servers")
    autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
