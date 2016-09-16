defmodule Cerberus.Schema do
  use Absinthe.Schema
  alias Cerberus.Users

  @desc "A user"
  object :user do
    field :id, :id
    field :email, :string
    field :password, :string
    field :token, :string
  end

  @desc "A user token"
  object :token do
    field :id, :id
    field :token, :string
  end

  query do
    @desc "Retrieve a user"
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

    @desc "Login a user"
    field :login, :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve fn %{email: email, password: password}, _ ->
        case Users.login(email, password) do
          :ok ->
            :ok
          :error ->
            :error
        end
      end
    end

    @desc "Authenticate a user's token"
    field :authenticate, :token do
      arg :id, non_null(:id)
      arg :token, non_null(:string)

      resolve fn %{id: id, token: token}, _ ->
        Users.validate(id, token)
      end
    end
  end

  mutation do
    @desc "Create a user"
    field :create, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve fn(params, _) ->
        case Users.create(params) do
          {:error, changeset} ->
            {:error, Users.format_changeset_errors(changeset)}
          {:ok, user} -> {:ok, user}
        end
      end
    end

    @desc "Update a user"
    field :update, type: :user do
      arg :id, non_null(:id)
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve fn(params, _) -> Users.update(params.id, params) end
    end
  end
end
