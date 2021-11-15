defmodule Budget.Repo.Migrations.AddCreditCardBooleanToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :credit_card, :boolean
    end
  end
end
