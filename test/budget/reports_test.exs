defmodule Budget.ReportsTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Reports

  describe "get_totals_by_category/2" do
    setup do
      sc1 = insert(:subcategory)
      sc2 = insert(:subcategory)
      stop = Date.utc_today()
      start = Date.add(stop, -5)
      insert_list(5, :transaction, subcategory: sc1, value: 10)
      insert_list(3, :transaction, subcategory: sc2, value: 20)

      %{
        category1: sc1.category,
        category2: sc2.category,
        stop: stop,
        start: start
      }
    end

    test "returns a hash of totals by category name", %{
      stop: stop,
      start: start,
      category1: category1,
      category2: category2
    } do
      expected = %{category1.name => Decimal.new("50"), category2.name => Decimal.new("60")}
      assert expected == Reports.get_totals_by_category(start, stop)
    end
  end
end
