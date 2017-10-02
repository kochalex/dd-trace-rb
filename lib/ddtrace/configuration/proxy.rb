module Datadog
  class Configuration
    # Proxy provides a hash-like interface for fetching/setting configurations
    class Proxy
      def initialize(integration)
        @integration = integration
      end

      def [](param)
        @integration.get_option(param)
      end

      def []=(param, value)
        @integration.set_option(param, value)
      end
    end
  end
end
