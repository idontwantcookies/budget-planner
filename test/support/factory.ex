defmodule Budget.Factory do
  use ExMachina.Ecto, repo: Budget.Repo
  alias Budget.Finance

  def transaction_factory do
    %Finance.Transaction{
      generated_at: Date.utc_today(),
      due_by: Date.utc_today(),
      completed_at: Date.utc_today(),
      amount: :rand.uniform_real(),
      description: sequence("transaction"),
      # from: sequence("account"),
      # to: sequence("account")
    }
  end

  # def item_factory do
  #   transaction = build(:transaction)

  #   %Finance.Item{
  #     description: sequence("transaction item"),
  #     amount: transaction.amount,
  #     transaction: transaction
  #   }
  # end
end
