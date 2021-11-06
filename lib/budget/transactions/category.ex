defmodule Budget.Transactions.Category do
  @moduledoc """
  Major categories used for organizing budget into bug chunks (specially in annual reports).
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Budget.Transactions.Subcategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:name]
  @fields @required_fields

  @type t :: %__MODULE__{
          name: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "categories" do
    field :name, :string

    has_many :subcategories, Subcategory
    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
