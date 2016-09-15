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

  mutation do
    @desc "Create a user"
    field :user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve fn(params, _) -> Users.create(params) end
    end
  end
end
