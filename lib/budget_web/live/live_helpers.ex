defmodule BudgetWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @moduledoc """
  Renders a component inside the `BudgetWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal BudgetWeb.TransactionLive.FormComponent,
        id: @transaction.id || :new,
        action: @live_action,
        transaction: @transaction,
        return_to: Routes.transaction_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(BudgetWeb.ModalComponent, modal_opts)
  end
end
