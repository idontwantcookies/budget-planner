defmodule BudgetPlanning.Factory do
  use ExMachina.Ecto, repo: BudgetPlanning.Repo

  alias BudgetPlanning.Transactions.{Category, Subcategory}

  def category_factory do
    %Category{
      name: sequence("Category#")
    }
  end

  def subcategory_factory do
    %Subcategory{
      category: build(:category),
      name: sequence("Subcategory#")
    }
  end
end
