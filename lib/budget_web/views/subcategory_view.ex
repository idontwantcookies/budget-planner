defmodule BudgetWeb.SubcategoryView do
  use BudgetWeb, :view

  def available_categories do
    Budget.Transactions.list_categories()
  end
end
