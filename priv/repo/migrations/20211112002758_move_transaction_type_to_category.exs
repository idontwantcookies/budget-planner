defmodule Budget.Repo.Migrations.MoveTransactionTypeToCategory do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :type
    end

    alter table(:categories) do
      add :type, :string, null: false
    end
  end
end
