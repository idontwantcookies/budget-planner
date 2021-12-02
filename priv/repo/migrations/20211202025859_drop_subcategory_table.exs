defmodule Budget.Repo.Migrations.DropSubcategoryTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :subcategory_id
      add :category_id, references(:categories, on_delete: :restrict, type: :binary_id), null: false
    end

    drop table(:subcategories)
  end
end
