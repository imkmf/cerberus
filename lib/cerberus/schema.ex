defmodule Cerberus.Schema do
  use Absinthe.Schema
  alias Cerberus.{Repo,User}
  import Ecto.Query, only: [from: 2]

  @desc "A user"
  object :user do
    field :id, :id
    field :email, :string
  end

  query do
    field :user, :user do
      arg :id, non_null(:id)

      resolve fn %{id: user_id}, _ ->
        case Repo.get(User, user_id) do
          nil ->
            {:error, "No user found"}
          user ->
            {:ok, user}
        end
      end
    end
  end
end
