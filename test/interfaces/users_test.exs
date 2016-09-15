defmodule Cerberus.UsersTest do
  use Cerberus.ModelCase, async: true
  alias Cerberus.{User, Users}

  @valid_attrs %{email: "foo@bar.com", password: "foobar"}
  @invalid_attrs %{}

  test "can't find a user for an invalid uuid" do
    assert Users.find("foo") == nil
  end

  test "can find a user for a valid uuid" do
    # Create user to key off of
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, saved} = Repo.insert(changeset)

    assert Users.find(saved.id) == saved
  end

  test "can fail with bad data" do
    {state, _} = Users.create(@invalid_attrs)
    assert state == :error
  end

  test "can create a new user" do
    {:ok, user} = Users.create(@valid_attrs)
    assert user.email == @valid_attrs.email
  end
end
