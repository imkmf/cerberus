defmodule Cerberus.Schema do
  use Absinthe.Schema
  alias Cerberus.Users

  @desc "A user"
  object :user do
    field :id, :id
    field :email, :string
  end

  query do
    field :user, :user do
      arg :id, non_null(:id)

      resolve fn %{id: user_id}, _ ->
        case Users.find(user_id) do
          nil ->
            {:error, "No user found"}
          user ->
            {:ok, user}
        end
      end
    end
  end
end
