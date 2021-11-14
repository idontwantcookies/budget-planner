defmodule BudgetWeb.TransactionLiveTest do
  use BudgetWeb.ConnCase

  import Phoenix.LiveViewTest
  import Budget.Factory

  @create_attrs %{
    description: "some description",
    due_by: %{day: 11, month: 11, year: 2021},
    status: :pending,
    value: "120.5"
  }
  @update_attrs %{
    description: "some updated description",
    due_by: %{day: 12, month: 11, year: 2021},
    status: :completed,
    value: "456.7"
  }
  @invalid_attrs %{
    description: nil,
    due_by: %{day: 30, month: 2, year: 2021},
    value: nil
  }

  describe "Index" do
    setup do
      %{transaction: insert(:transaction)}
    end

    test "lists all transactions", %{conn: conn, transaction: transaction} do
      {:ok, _index_live, html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Listing Transactions"
      assert html =~ transaction.description
    end

    @tag :wip
    test "saves new transaction", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("a", "New Transaction") |> render_click() =~
               "New Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :new))

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction created successfully"
      assert html =~ "some description"
    end

    test "updates transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live
             |> element("#transaction-#{transaction.id} a", transaction.description)
             |> render_click() =~ "Edit Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :edit, transaction))

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("#transaction-#{transaction.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#transaction-#{transaction.id}")
    end
  end

  describe "Show" do
    setup do
      %{transaction: insert(:transaction)}
    end

    test "updates transaction within modal", %{conn: conn, transaction: transaction} do
      {:ok, show_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert show_live |> element("a", transaction.description) |> render_click() =~
               "Edit Transaction"

      assert_patch(show_live, Routes.transaction_index_path(conn, :edit, transaction))

      assert show_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#transaction-form", transaction: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated description"
    end
  end
end
