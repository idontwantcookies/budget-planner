defmodule BudgetWeb.TransactionControllerTest do
  use BudgetWeb.ConnCase
  import Budget.Factory

  describe "index/2" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  describe "new/2" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "create/2" do
    test "redirects to show when data is valid", %{conn: conn} do
      attrs = params_with_assocs(:transaction)
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_path(conn, :show, id)

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = %{description: "description", due_by: nil, status: nil, type: nil, value: nil}
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: attrs)
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "edit/2" do
    setup :create_transaction

    test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
      conn = get(conn, Routes.transaction_path(conn, :edit, transaction))
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "update/2" do
    setup :create_transaction

    test "redirects when data is valid", %{conn: conn, transaction: transaction} do
      attrs = params_with_assocs(:transaction)
      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: attrs)

      assert redirected_to(conn) == Routes.transaction_path(conn, :show, transaction)

      conn = get(conn, Routes.transaction_path(conn, :show, transaction))
      assert html_response(conn, 200) =~ attrs[:description]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      attrs = %{value: nil, type: nil, due_by: nil, status: nil}

      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: attrs)

      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "delete/2" do
    setup :create_transaction

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert redirected_to(conn) == Routes.transaction_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(_), do: %{transaction: insert(:transaction)}
end
