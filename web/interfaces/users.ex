defmodule Cerberus.Users do
  alias Cerberus.{Repo,User}

  def find(user_id) do
    case Ecto.UUID.cast(user_id) do
      :error -> nil
      {:ok, uuid} -> Repo.get(User, uuid)
    end
  end

  def find_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def login(email, password) do
    user = find_by_email(email)
    case User.compare_password(user, password) do
      true -> {:ok, User.generate_token(user)}
      false -> :error
    end
  end

  def validate(id, token) do
    user = find(id)
    case User.verify_token(user, token) do
      {:ok, token} -> {:ok, token}
      :error -> {:error, "Unauthorized"}
    end
  end

  def create(params) do
    user = %User{}
    |> User.changeset(params)
    |> Repo.insert
  end

  def update(id, params) do
    case find(id) do
      nil -> false
      user ->
        changeset = User.changeset(user, params)
        Repo.update(changeset)
    end
  end

  def format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, _ ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)

      # hash
      # |> Enum.map(fn ->
      #   {key, value} = hash
      #   key <> value
      # end)
      # |> Enum.join(".")
    end)
  end
end
