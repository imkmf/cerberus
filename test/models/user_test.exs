defmodule Cerberus.UserTest do
  use Cerberus.ModelCase

  alias Cerberus.User
  alias Comeonin.Bcrypt

  @valid_attrs %{email: "foo@bar.com", password: "foobar"}
  @invalid_attrs %{}

  @duplicate_email_error [email: {"has already been taken", []}]
  @invalid_email_error [email: {"has invalid format", []}]

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
    {:ok, _} = Repo.insert(changeset)

    changeset_two = User.changeset(%User{}, @valid_attrs)
    {:error, error_changeset} = Repo.insert(changeset_two)
    assert @duplicate_email_error == error_changeset.errors
  end

  test "email is validated" do
    attrs = Dict.merge(@valid_attrs, %{email: "test"})
    changeset = User.changeset(%User{}, attrs)

    {:error, error_changeset} = Repo.insert(changeset)
    assert @invalid_email_error == error_changeset.errors
  end

  test "does not store a password" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Dict.get(changeset.changes, :password) == :nil
  end

  test "should passthrough when the changeset is uneventful" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "should accept a password and encrypt it" do
    changeset = User.changeset(%User{}, @valid_attrs)
    encrypted_pw = Dict.get(changeset.changes, :encrypted_password)
    compare_pw = Bcrypt.checkpw("foobar", encrypted_pw)

    assert compare_pw
  end
end
