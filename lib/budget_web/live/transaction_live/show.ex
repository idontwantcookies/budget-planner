defmodule BudgetWeb.TransactionLive.Show do
  use BudgetWeb, :live_view

  alias Budget.Finances

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:transaction, Finances.get_transaction!(id))}
  end

  defp page_title(:show), do: "Show Transaction"
  defp page_title(:edit), do: "Edit Transaction"
end
