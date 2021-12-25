defmodule Budget.FinanceTest do
  use Budget.DataCase
  alias Budget.Finance
  alias Budget.Finance.Transaction

  describe "create/1" do
    test "inserts a new transaction" do
      attrs = params_for(:transaction)
      assert {:ok, %Finance.Transaction{}} = Finance.create_transaction(attrs)
    end
  end
end
