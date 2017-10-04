module Datadog
  # FilterPipeline handles trace filtering based on user-defined filters
  class FilterPipeline
    def initialize
      @mutex = Mutex.new
      @filters = []
    end

    def call(trace)
      @mutex.synchronize do
        trace.reject { |span| drop_it?(span) }
      end
    end

    def add_filter(filter = nil, &block)
      callable = filter || block

      raise(ArgumentError) unless callable.respond_to?(:call)

      @mutex.synchronize { @filters << callable }
    end

    private

    def drop_it?(span)
      @filters.any? do |filter|
        filter.call(span) rescue false
      end
    end
  end
end
