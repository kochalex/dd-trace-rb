module Datadog
  module Contrib
    module Redis
      # Quantize contains Redis-specific resource quantization tools.
      module Quantize
        PLACEHOLDER = '?'.freeze
        TOO_LONG_MARK = '...'.freeze
        VALUE_MAX_LEN = 100
        CMD_MAX_LEN = 1000

        module_function

        def format_arg(arg)
          str = arg.to_s
          Utils.truncate(str, VALUE_MAX_LEN, TOO_LONG_MARK)
        rescue StandardError => e
          Datadog::Tracer.log.debug("non formattable Redis arg #{str}: #{e}")
          PLACEHOLDER
        end

        def format_command_args(command_args)
          cmd = command_args.map { |x| format_arg(x) }.join(' ')
          Utils.truncate(cmd, CMD_MAX_LEN, TOO_LONG_MARK)
        end
      end
    end
  end
end
