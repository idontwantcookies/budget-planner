defmodule BudgetWeb.SubcategoryLive.FormComponent do
  use BudgetWeb, :live_component

  alias Budget.Finances

  @impl true
  def update(%{subcategory: subcategory} = assigns, socket) do
    changeset = Finances.change_subcategory(subcategory)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"subcategory" => subcategory_params}, socket) do
    changeset =
      socket.assigns.subcategory
      |> Finances.change_subcategory(subcategory_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"subcategory" => subcategory_params}, socket) do
    save_subcategory(socket, socket.assigns.action, subcategory_params)
  end

  defp save_subcategory(socket, :edit, subcategory_params) do
    case Finances.update_subcategory(socket.assigns.subcategory, subcategory_params) do
      {:ok, _subcategory} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subcategory updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_subcategory(socket, :new, subcategory_params) do
    case Finances.create_subcategory(subcategory_params) do
      {:ok, _subcategory} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subcategory created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
