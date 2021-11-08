defmodule Budget.Finances.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.{Enum, UUID}
  alias Budget.Finances.Subcategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields [:value, :due_by, :subcategory_id]
  @fields [:description, :status, :type | @required_fields]

  @type t :: %__MODULE__{
          id: UUID.t(),
          description: String.t(),
          due_by: Date.t(),
          status: Enum.t(:pending, :scheduled, :completed, :cancelled),
          type: Enum.t(:income, :expense),
          value: Decimal.t(),
          subcategory_id: UUID.t()
        }

  schema "transactions" do
    field :description, :string, default: ""
    field :due_by, :date
    field :status, Enum, values: [:pending, :scheduled, :completed, :cancelled], default: :pending
    field :type, Enum, values: [:income, :expense], default: :expense
    field :value, :decimal

    belongs_to :subcategory, Subcategory
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
