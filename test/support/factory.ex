defmodule Budget.Factory do
  @moduledoc """
  This module provides a factory for creating Budget objects.
  """

  use ExMachina.Ecto, repo: Budget.Repo
  alias Budget.Finances.{Category, Transaction}

  def category_factory do
    %Category{
      name: sequence("Category#"),
      type: :expense
    }
  end

  def transaction_factory do
    %Transaction{
      category: build(:category),
      description: sequence("Transaction#"),
      due_by: Date.utc_today(),
      status: :pending,
      value: Decimal.new("#{:rand.uniform() * 1000}")
    }
  end
end
