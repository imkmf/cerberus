defmodule Cerberus.User do
  use Cerberus.Web, :model
  alias Joken
  alias Comeonin.Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  def compare_password(nil, _) do
    Bcrypt.dummy_checkpw
  end

  def compare_password(user, pw_to_compare) do
    Bcrypt.checkpw(pw_to_compare, user.encrypted_password)
  end

  def generate_token(user) do
    secret = Application.get_env(:cerberus, :secret_key)
    |> Joken.hs256

    %{user_id: user.id}
    |> Joken.token
    |> Joken.with_validation("user_id", &(&1 == user.id))
    |> Joken.with_signer(secret)
    |> Joken.sign
    |> Joken.get_compact
  end

  def verify_token(token, user) do
    secret = Application.get_env(:cerberus, :secret_key)
    |> Joken.hs256

    verified = token
    |> Joken.token
    |> Joken.with_validation("user_id", &(&1 == user.id))
    |> Joken.with_signer(secret)
    |> Joken.verify

    case verified.errors do
      nil -> :ok
      _ -> :error
    end
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
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> encrypt_password()
  end
end
