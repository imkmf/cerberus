defmodule Cerberus.UserTest do
  use Cerberus.ModelCase

  alias Cerberus.User

  @valid_attrs %{email: "foo@bar.com", encrypted_password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "emails are unique" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)

    changeset_two = User.changeset(%User{}, @valid_attrs)
    {:error, error_changeset} = Repo.insert(changeset_two)
    assert false == error_changeset.valid?
  end
end
