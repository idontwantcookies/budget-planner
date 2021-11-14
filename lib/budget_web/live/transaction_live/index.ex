defmodule BudgetWeb.TransactionLive.Index do
  use BudgetWeb, :live_view

  alias Budget.Finances
  alias Budget.Finances.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:transactions, list_transactions())
     |> assign(:subcategories, get_subcategories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Finances.get_transaction!(id))
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

    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  defp list_transactions do
    Finances.list_transactions(subcategory: :category)
  end

  def get_subcategories do
    :category
    |> Finances.list_subcategories()
    |> Enum.sort_by(fn sc -> {sc.category.name, sc.inserted_at} end)
    |> Enum.map(fn sc -> {sc.category.name <> "> " <> sc.name, sc.id} end)
  end
end
