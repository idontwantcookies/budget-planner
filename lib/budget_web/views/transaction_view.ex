defmodule BudgetWeb.TransactionView do
  use BudgetWeb, :view
  alias Budget.Finances.Transaction

  @spec available_subcategories :: [BudgetWeb.Subcategory, ...]
  def available_subcategories do
    Budget.Finances.list_subcategories(:category)
    |> Enum.sort_by(fn sc -> {sc.category.name, sc.inserted_at} end)
    |> Enum.map(fn sc -> {sc.category.name <> "> " <> sc.name, sc.id} end)
  end
end
