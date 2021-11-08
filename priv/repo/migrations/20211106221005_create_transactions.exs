defmodule Budget.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :decimal, null: false
      add :due_by, :date, null: false
      add :status, :string, null: false
      add :type, :string, null: false
      add :description, :string, null: false
      add :subcategory_id, references(:subcategories, on_delete: :restrict, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:subcategory_id])
  end
end
