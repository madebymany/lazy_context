defmodule LazyContext.Examples.Repo.Migrations.CreateExampleTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :age, :integer
      add :email, :string
    end

    create table(:cats) do
      add :name, :string
      add :colour, :string
      add :cuteness, :integer
      add :owner_id, references(:users)
    end

    create table(:dogs) do
      add :name, :string
      add :colour, :string
      add :cuteness, :integer
      add :owner_id, references(:users)
    end

    create table(:ferrets) do
      add :name, :string
      add :colour, :string
      add :cuteness, :integer
      add :owner_id, references(:users)
      add :social_security_number, :integer
    end

    create unique_index(:ferrets, [:social_security_number])
  end
end
