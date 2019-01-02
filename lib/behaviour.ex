defmodule LazyContext.Behaviour do
  @moduledoc false

  defmacro with_behaviour(schema, fnames, expression) do
    module_name = :"#{System.unique_integer()}_behaviour"

    quote do
      defmodule unquote(module_name) do
        @type context_struct() :: %unquote(schema){}
        @type repo_ok_or_error() :: {:ok, context_struct()} | {:error, Ecto.Changeset.t()}

        @callback unquote(fnames.list)() :: list(context_struct())

        @callback unquote(fnames.get)(integer()) :: context_struct() | nil
        @callback unquote(fnames.get)(map()) :: context_struct() | nil
        @callback unquote(fnames.get!)(integer()) :: context_struct() | no_return()
        @callback unquote(fnames.get!)(map()) :: context_struct() | no_return()

        @callback unquote(fnames.create)() :: repo_ok_or_error()
        @callback unquote(fnames.create)(map()) :: repo_ok_or_error()
        @callback unquote(fnames.create!)() :: context_struct() | no_return()
        @callback unquote(fnames.create!)(map()) :: context_struct() | no_return()

        @callback unquote(fnames.create_or_update)(map()) :: repo_ok_or_error()
        @callback unquote(fnames.create_or_update!)(map()) :: context_struct() | no_return()

        @callback unquote(fnames.update)(term(), map()) :: repo_ok_or_error() | nil
        @callback unquote(fnames.update!)(term(), map()) :: context_struct() | no_return()

        @callback unquote(fnames.delete)(map()) :: repo_ok_or_error() | nil
        @callback unquote(fnames.delete!)(map()) :: context_struct() | no_return()

        @callback unquote(fnames.change)(map()) :: Ecto.Changeset.t()
      end

      @behaviour unquote(module_name)
      unquote(expression)
      defoverridable unquote(module_name)
    end
  end
end
