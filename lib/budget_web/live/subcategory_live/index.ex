defmodule BudgetWeb.SubcategoryLive.Index do
  use BudgetWeb, :live_view

  alias Budget.Finances
  alias Budget.Finances.Subcategory

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:subcategories, list_subcategories())
     |> assign(:categories, get_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Subcategory")
    |> assign(:subcategory, Finances.get_subcategory!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Subcategory")
    |> assign(:subcategory, %Subcategory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Subcategories")
    |> assign(:subcategory, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subcategory = Finances.get_subcategory!(id)
    {:ok, _} = Finances.delete_subcategory(subcategory)

    {:noreply, assign(socket, :subcategories, list_subcategories())}
  end

  defp list_subcategories,
    do: Finances.list_subcategories(:category) |> Enum.sort_by(&{&1.category.name, &1.name})

  defp get_categories,
    do: Finances.list_categories() |> Enum.sort_by(& &1.name) |> Enum.map(&{&1.name, &1.id})
end
