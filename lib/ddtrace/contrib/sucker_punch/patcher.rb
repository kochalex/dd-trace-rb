module Datadog
  module Contrib
    module SuckerPunch
      SERVICE = 'sucker_punch'.freeze
      COMPATIBLE_WITH = Gem::Version.new('2.0.0')

      # Responsible for hooking the instrumentation into `sucker_punch`
      module Patcher
        @patched = false

        module_function

        def patch
          return @patched if patched? || !compatible?

          require 'ddtrace/ext/app_types'
          require_relative 'exception_handler'
          require_relative 'instrumentation'

          add_pin!
          ExceptionHandler.patch!
          Instrumentation.patch!

          @patched = true
        rescue => e
          Datadog::Tracer.log.error("Unable to apply SuckerPunch integration: #{e}")
          @patched
        end

        def patched?
          @patched
        end

        def compatible?
          return unless defined?(::SuckerPunch::VERSION)

          Gem::Version.new(::SuckerPunch::VERSION) >= COMPATIBLE_WITH
        end

        def add_pin!
          Pin.new(SERVICE, app_type: Ext::AppTypes::WORKER).tap do |pin|
            pin.onto(::SuckerPunch)
          end
        end

        private_class_method :compatible?, :add_pin!
      end
    end
  end
end
