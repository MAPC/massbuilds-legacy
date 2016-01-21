require 'test_helper'

class DevelopmentsSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= DevelopmentsSerializer.new(
      [developments(:one), developments(:two)]
    )
  end
  alias_method :base, :serializer

  test "#developments" do
    refute_empty base.developments
  end

  test "prevents empty developments" do
    assert_raises(ArgumentError) {
      DevelopmentsSerializer.new([])
    }
  end

  test "#to_csv" do
    assert_respond_to base, :to_csv
    assert_equal csv_array, base.to_csv
  end

  private

    def csv_array
      [
       ["name", "address", ""],
       ["Godfrey Hotel", "505 Washington Street", "Boston", "MA", '02111', 12, 75, :normal],
       ["Woop Woop", "That's the sound of", "The poli", "CE", '02118', 200, 1000, :normal]
      ]
    end
end
