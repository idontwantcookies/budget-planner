defmodule Budget.Transactions.Subcategory do
  @moduledoc """
  Minor category, used for fine-tuning categorization, usually for monthy budget reports.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Budget.Transactions.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:name, :category_id]
  @fields @required_fields

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          category_id: Ecto.UUID.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "subcategories" do
    field :name, :string

    belongs_to :category, Category
    timestamps()
  end

  # @spec changeset(__MODULE__.t(), map()) :: Changeset
  def changeset(subcategory, attrs) do
    subcategory
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
