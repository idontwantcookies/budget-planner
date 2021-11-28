defmodule Budget.ReportsTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Reports

  setup :today

  describe "get_monthly_report/2" do
    test "sums totals per category", %{year: year, month: month} do
      category = insert(:category)
      subcategory = insert(:subcategory, category: category)
      insert_list(3, :transaction, subcategory: subcategory, value: 10)

      assert %{category => Decimal.new("30")} == Reports.get_monthly_report(year, month)
    end

    test "groups multiple subcategories into their category", %{year: year, month: month} do
      category = insert(:category)
      subcat1 = insert(:subcategory, category: category)
      subcat2 = insert(:subcategory, category: category)
      insert_list(3, :transaction, subcategory: subcat1, value: 10)
      insert_list(5, :transaction, subcategory: subcat2, value: 20)

      assert %{category => Decimal.new("130")} == Reports.get_monthly_report(year, month)
    end
  end

  describe "get_yearly_report/1" do
    setup :today

    test "returns a hash of totals in nested groupbys", %{year: year, month: month} do
      category = insert(:category)
      subcategory = insert(:subcategory, category: category)
      insert_list(3, :transaction, subcategory: subcategory, value: 10)

      assert %{category => %{subcategory => %{month => Decimal.new("30")}}} ==
               Reports.get_yearly_report(year)
    end
  end

  defp today(context) do
    %{month: month, year: year} = Date.utc_today()
    Map.merge(context, %{month: month, year: year})
  end
end
