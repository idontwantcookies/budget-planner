defmodule Budget.Repo.Migrations.MakeCategoryNamesUnique do
  use Ecto.Migration

  def change do
    create unique_index(:categories, [:name])
    create unique_index(:subcategories, [:name, :category_id])
  end
end
