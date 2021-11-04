defmodule BudgetPlanningWeb.SubcategoryView do
  use BudgetPlanningWeb, :view

  def available_categories do
    BudgetPlanning.Transactions.list_categories()
  end
end
