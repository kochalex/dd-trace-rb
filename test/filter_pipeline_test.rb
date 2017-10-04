require 'ddtrace/filter_pipeline'

module Datadog
  class FilterPipelineTest < Minitest::Test
    def setup
      @pipeline = FilterPipeline.new
    end

    def test_empty_pipeline
      assert_equal([1, 2, 3, 4], @pipeline.call([1, 2, 3, 4]))
    end

    def test_filter_addition
      assert(@pipeline.add_filter(->(_) { true }))

      assert(@pipeline.add_filter { |_| false })

      assert_raises(ArgumentError) do
        @pipeline.add_filter('foobar')
      end
    end

    def test_filtering_behavior
      @pipeline.add_filter(&:even?)

      assert_equal([1, 3], @pipeline.call([1, 2, 3, 4]))
    end

    def test_filtering_composability
      @pipeline.add_filter(&:even?)
      @pipeline.add_filter { |num| (num % 3).zero? }

      assert_equal([1], @pipeline.call([1, 2, 3, 4]))
    end

    def test_filtering_resilience
      @pipeline.add_filter(&:even?)
      @pipeline.add_filter { |_| raise('Boom') }

      assert_equal([1, 3], @pipeline.call([1, 2, 3, 4]))
    end
  end
end
