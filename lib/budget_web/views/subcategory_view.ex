defmodule BudgetWeb.SubcategoryView do
  use BudgetWeb, :view

  @spec available_categories :: [BudgetWeb.Category, ...]
  def available_categories do
    Budget.Finances.list_categories()
    |> Enum.sort_by(fn c -> c.name end)
    |> Enum.map(fn c -> {c.name, c.id} end)
  end
end
