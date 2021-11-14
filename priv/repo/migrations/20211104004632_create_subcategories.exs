defmodule Budget.Repo.Migrations.CreateSubcategories do
  use Ecto.Migration

  def change do
    create table(:subcategories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      add :category_id, references(:categories, on_delete: :restrict, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:subcategories, [:category_id])
  end
end
