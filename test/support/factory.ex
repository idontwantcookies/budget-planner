defmodule Budget.Factory do
  @moduledoc """
  This module provides a factory for creating Budget objects.
  """

  use ExMachina.Ecto, repo: Budget.Repo

  alias Budget.Transactions.{Category, Subcategory}

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
