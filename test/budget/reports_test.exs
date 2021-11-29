defmodule Budget.ReportsTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Reports

  describe "simple_report/1" do
    test "sums totals per category" do
      category = build(:category)
      subcategory = build(:subcategory, category: category)
      transactions = build_list(3, :transaction, subcategory: subcategory, value: 10)

      assert %{category => Decimal.new("30")} == Reports.simple_report(transactions)
    end

    test "groups multiple subcategories into their category" do
      category = build(:category)
      subcat1 = build(:subcategory, category: category)
      subcat2 = build(:subcategory, category: category)

      transactions =
        build_list(3, :transaction, subcategory: subcat1, value: 10) ++
          build_list(5, :transaction, subcategory: subcat2, value: 20)

      assert %{category => Decimal.new("130")} == Reports.simple_report(transactions)
    end
  end

  describe "detailed_report/1" do
    test "returns a hash of totals in nested groupbys" do
      category = insert(:category)
      subcategory = insert(:subcategory, category: category)
      transactions = insert_list(3, :transaction, subcategory: subcategory, value: 10)
      month = Date.utc_today().month

      assert %{category => %{subcategory => %{month => Decimal.new("30")}}} ==
               Reports.detailed_report(transactions)
    end
  end
end
