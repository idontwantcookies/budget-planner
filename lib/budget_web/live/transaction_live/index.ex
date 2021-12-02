defmodule BudgetWeb.TransactionLive.Index do
  use BudgetWeb, :live_view

  alias Budget.Finances
  alias Budget.Finances.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(transactions: get_transactions(), categories: get_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    transaction = Finances.get_transaction!(id, :category)

    socket
    |> assign(
      page_title: "Edit Transaction",
      transaction: transaction,
      category: transaction.category
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Finances.get_transaction!(id)
    {:ok, _} = Finances.delete_transaction(transaction)

    {:noreply, assign(socket, :transactions, get_transactions())}
  end

  defp get_transactions do
    Finances.list_transactions(:category)
  end

  defp get_categories do
    Finances.list_categories()
  end
end
