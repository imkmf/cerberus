defmodule Cerberus.Users do
  alias Cerberus.{Repo,User}

  def find(user_id) do
    case Ecto.UUID.cast(user_id) do
      :error -> nil
      {:ok, uuid} -> Repo.get(User, uuid)
    end
  end

  def create(params) do
    %User{}
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
end
