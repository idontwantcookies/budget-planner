defmodule BudgetPlanning.Transactions.CategorySeeds do
  alias BudgetPlanning.Transactions

  def seed! do
    [
      "Children",
      "Debt",
      "Education",
      "Entertainment",
      "Everyday",
      "Gifts",
      "Health/medical",
      "Home",
      "Insurance",
      "Investments",
      "Pets",
      "Technology",
      "Transportation",
      "Travel",
      "Utilities"
    ]
    |> Enum.each(fn name -> {:ok, _category} = Transactions.create_category(%{name: name}) end)

    :ok
  end
end
