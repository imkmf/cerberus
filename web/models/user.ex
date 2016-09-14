defmodule Cerberus.User do
  use Cerberus.Web, :model
  alias Comeonin.Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  defp encrypt_password(changeset) do
    case get_field(changeset, :password) do
      nil ->
        changeset
      password ->
        encrypted_password = Bcrypt.hashpwsalt(password)

        changeset
        |> delete_change(:password)
        |> put_change(:encrypted_password, encrypted_password)
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> encrypt_password()
  end
end
