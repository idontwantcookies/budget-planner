defmodule BudgetWeb.SubcategoryView do
  use BudgetWeb, :view

  def available_categories do
    Budget.Finances.list_categories()
  end
end
