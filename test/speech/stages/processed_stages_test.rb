require 'test_helper'

class Speech::Stages::ProcessedStagesTest < Test::Unit::TestCase

  class TargetWithoutStatus
    include Speech::Stages::ProcessHelper
  end

  class TargetWithProcessedStagesMask
    include Speech::Stages::ProcessHelper

    attr_accessor :processed_stages_mask
  end

  def setup
    @klass  = Speech::Stages::ProcessedStages
    @target = TargetWithoutStatus.new
    @stages = @klass.new(@target)
  end

  def test_bit_of
    assert_equal 2**0, @klass.bit_of(:build)
    assert_equal 2**1, @klass.bit_of(:encode)
    assert_equal 2**2, @klass.bit_of(:convert)
    assert_equal 2**3, @klass.bit_of(:extract)
    assert_equal 2**4, @klass.bit_of(:split)
    assert_equal 2**5, @klass.bit_of(:perform)
  end

  def test_bits
    assert_equal @klass.bit_of(:build), @klass.bits(:build)
    assert_equal @klass.bit_of(:build) + @klass.bit_of(:encode),
      @klass.bits([:build, :encode])
    assert_equal @klass.bit_of(:build) + @klass.bit_of(:encode) + @klass.bit_of(:convert),
      @klass.bits([:build, :encode, :convert])
    assert_equal @klass.bit_of(:build) + @klass.bit_of(:encode) + @klass.bit_of(:convert) + @klass.bit_of(:extract),
      @klass.bits([:build, :encode, :convert, :extract])
  end

  def test_initialize_target
    assert_equal @target, @stages.target
  end

  def test_initialize_values
    stages = Speech::Stages::ProcessedStages.new(@target, :build)
    assert_equal [:build], stages.get
  end

  def test_initialize_with_empty_stages
    assert_equal [], @stages.get
  end

  def test_set_and_get
    @stages.set([:build, :encode, :convert])
    assert_equal [:build, :encode, :convert], @stages.get
    @stages.set([:extract])
    assert_equal [:extract], @stages.get
  end

  def test_add
    @stages.add(:encode)
    assert_equal [:encode], @stages.get
    @stages.add(:convert)
    assert_equal [:encode, :convert], @stages.get
  end

  def test_push
    @stages.push(:encode)
    assert_equal [:encode], @stages.get
    @stages.push(:convert)
    assert_equal [:encode, :convert], @stages.get
  end

  def test_push_operator
    @stages << :encode
    assert_equal [:encode], @stages.get
    @stages << :convert
    assert_equal [:encode, :convert], @stages.get
  end

  def test_should_be_equal_to_other_target
    @stages << :encode
    other_stages = Speech::Stages::ProcessedStages.new(@target, :encode)
    assert_equal true, @stages == other_stages
  end

  def test_should_not_be_equal_to_other_target
    @stages << :encode
    other_stages = Speech::Stages::ProcessedStages.new(@target, :build)
    assert_equal false, @stages == other_stages
  end

  def test_should_be_equal_to_object
    @stages << :encode
    assert_equal true, @stages == :encode
  end

  def test_should_not_be_equal_to_object
    @stages << :build
    assert_equal false, @stages == :encode
  end

  def test_is_empty
    assert_equal true, @stages.empty?
  end

  def test_status_alias
    assert_equal @stages.bits, @stages.status
  end

  # with :processed_stages_mask

  def test_set_with_mask
    target = TargetWithProcessedStagesMask.new
    stages = Speech::Stages::ProcessedStages.new(target)
    stages.set(:build)
    assert_equal target.processed_stages_mask, stages.bits
  end

  def test_add_with_mask
    target = TargetWithProcessedStagesMask.new
    stages = Speech::Stages::ProcessedStages.new(target)
    stages.add(:build)
    assert_equal target.processed_stages_mask, stages.bits
  end

  def test_initialize_from_target
    target = TargetWithProcessedStagesMask.new
    target.processed_stages_mask = 1
    stages = Speech::Stages::ProcessedStages.new(target)
    assert_equal [:build], stages.get
  end
end
