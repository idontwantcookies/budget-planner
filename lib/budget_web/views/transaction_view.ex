defmodule BudgetWeb.TransactionView do
  use BudgetWeb, :view

  @spec available_subcategories :: [BudgetWeb.Subcategory, ...]
  def available_subcategories do
    Budget.Finances.list_subcategories(:category)
    |> Enum.sort_by(fn sc -> {sc.category_id, sc.name} end)
    |> Enum.map(fn sc -> {sc.name, sc.id} end)
  end
end
