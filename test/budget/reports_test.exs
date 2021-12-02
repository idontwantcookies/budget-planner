defmodule Budget.ReportsTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Reports

  describe "simple_report/1" do
    test "sums totals per category" do
      category = build(:category)
      transactions = build_list(3, :transaction, category: category, value: 10)

      assert %{category => Decimal.new("30")} == Reports.simple_report(transactions)
    end

    test "does not show categories without transactions" do
      category1 = build(:category)
      build(:category)
      transactions = build_list(3, :transaction, category: category1, value: 10)

      report = Reports.simple_report(transactions)
      assert %{category1 => Decimal.new("30")} == report
      assert Enum.count(report) == 1
    end
  end

  describe "detailed_report/1" do
    @tag :wip
    test "returns a hash of totals in nested groupbys" do
      category = insert(:category)
      transactions = insert_list(3, :transaction, category: category, value: 10)
      month = Date.utc_today().month

      assert %{category => %{month => Decimal.new("30")}} ==
               Reports.detailed_report(transactions)
    end
  end

  describe "per_credit_card/1" do
    test "returns credit card totals" do
      cc_transactions = insert_list(3, :transaction, value: 10, credit_card: true)
      debit_transactions = insert_list(5, :transaction, value: 5, credit_card: false)

      assert Reports.per_credit_card(cc_transactions ++ debit_transactions) ==
               %{
                 true: Decimal.new("30"),
                 false: Decimal.new("25")
               }
    end

    test "returns empty values when there's not credit card info" do
      assert Reports.per_credit_card([]) == %{true: 0, false: 0}
    end
  end
end
