defmodule Budget.Factory do
  @moduledoc """
  This module provides a factory for creating Budget objects.
  """

  use ExMachina.Ecto, repo: Budget.Repo
  alias Budget.Finances.{Category, Subcategory, Transaction}

  def category_factory do
    %Category{
      name: sequence("Category#"),
      type: :expense
    }
  end

  def subcategory_factory do
    %Subcategory{
      category: build(:category),
      name: sequence("Subcategory#")
    }
  end

  def transaction_factory do
    %Transaction{
      subcategory: build(:subcategory),
      description: sequence("Transaction#"),
      due_by: Date.utc_today(),
      status: :pending,
      value: Decimal.new("#{:rand.uniform() * 1000}")
    }
  end
end
