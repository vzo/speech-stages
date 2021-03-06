module Speech
  module Stages
    class ProcessedStages
      include Enumerable

      PROCESSED_STAGES = {
        build: 2**0,
        encode: 2**1,
        convert: 2**2,
        extract: 2**3,
        split: 2**4,
        perform: 2**5
      }

      attr_accessor :bits
      attr_reader :target

      def initialize(target, values = nil)
        @target = target
        if @target.respond_to?(:processed_stages_mask)
          @bits = @target.send(:processed_stages_mask)
        else
          @bits = 0
        end
        set(values) if values
      end

      class << self

        def bit_of(number_or_value)
          numbers = PROCESSED_STAGES.map {|k,v| number_or_value.is_a?(Fixnum) ? v : k}
          index   = numbers.index(number_or_value.is_a?(Fixnum) ? number_or_value : number_or_value.to_sym)
          index ? 2**index : 0
        end

        def bits(values)
          new_keys = ([values].flatten.map(&:to_sym) & PROCESSED_STAGES.keys)
          new_keys.sum {|d| bit_of(d)}
        end

      end # class

      def set(values)
        if values.is_a?(self.class)
          new_keys = values.to_a
        else
          new_keys = ([values].flatten.map(&:to_sym) & PROCESSED_STAGES.keys)
        end
        self.bits = new_keys.sum {|d| self.class.bit_of(d)}
        if @target.respond_to?(:processed_stages_mask=)
          @target.send(:processed_stages_mask=, self.bits)
        end
        self
      end

      def get
        PROCESSED_STAGES.keys.reject {|d| ((bits || 0) & self.class.bit_of(d)).zero?}
      end
      alias_method :to_a, :get

      def add(values)
        combined_keys = (([values].flatten.map(&:to_sym) & PROCESSED_STAGES.keys) | get)
        self.bits = combined_keys.sum {|d| self.class.bit_of(d)}
        if @target.respond_to?(:processed_stages_mask=)
          @target.send(:processed_stages_mask=, self.bits)
        end
        self
      end
      alias_method :push, :add

      def <<(values)
        add(values)
      end

      def ==(other_object)
        if other_object.is_a?(self.class)
          get == other_object.get
        else
          get == ProcessedStages.new(self, other_object).get
        end
      end

      def each(&block)
        get.each {|stage| block.call(stage)}
      end

      def empty?
        get.empty?
      end

      def status
        bits
      end

    end # ProcessedStages
  end # Stages
end # Speech
