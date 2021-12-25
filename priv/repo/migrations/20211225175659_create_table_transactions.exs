defmodule Budget.Repo.Migrations.CreateTableTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :generated_at, :date
      add :due_by, :date
      add :completed_at, :date
      add :amount, :decimal
      add :description, :string
      timestamps()
    end
  end
end
