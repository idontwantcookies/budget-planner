defmodule Budget.Finance do
  alias Budget.Repo
  alias Budget.Finance.Transaction

  def create_transaction(attrs) do
    attrs
    |> Transaction.changeset()
    |> Repo.insert()
  end
end
