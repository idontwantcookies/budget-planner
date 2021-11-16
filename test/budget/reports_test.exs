defmodule Budget.ReportsTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Reports

  describe "get_monthly_report/2" do
    setup do
      sc1 = insert(:subcategory)
      sc2 = insert(:subcategory)
      _empty_subcategory = insert(:subcategory, category: sc2.category)
      insert_list(5, :transaction, subcategory: sc1, value: 10)
      insert_list(3, :transaction, subcategory: sc2, value: 20)

      %{
        category1: sc1.category,
        category2: sc2.category,
        year: Date.utc_today().year,
        month: Date.utc_today().month
      }
    end

    test "returns a hash of totals by category name", %{
      year: year,
      month: month,
      category1: category1,
      category2: category2
    } do
      expected = %{category1.name => Decimal.new("50"), category2.name => Decimal.new("60")}
      assert expected == Reports.get_monthly_report(year, month)
    end
  end

  describe "get_monthly_report_by_category/2" do
    setup do
      sc1 = insert(:subcategory)
      sc2 = insert(:subcategory)
      insert_list(5, :transaction, subcategory: sc1, value: 10)
      insert_list(3, :transaction, subcategory: sc2, value: 20)

      insert_list(2, :transaction,
        subcategory: sc1,
        value: 5,
        due_by: Date.add(Date.utc_today(), -31)
      )

      %{
        category1: sc1.category,
        category2: sc2.category,
        subcategory1: sc1,
        subcategory2: sc2,
        year: Date.utc_today().year
      }
    end

    test "returns a hash of totals by category name", %{
      year: year,
      category1: cat1,
      category2: cat2,
      subcategory1: sc1,
      subcategory2: sc2
    } do
      expected = [
        {cat1.name, sc1.name, 10, Decimal.new(10)},
        {cat1.name, sc1.name, 11, Decimal.new(50)},
        {cat2.name, sc2.name, 11, Decimal.new(60)}
      ]

      assert expected == Reports.get_yearly_report(year)
    end
  end
end
