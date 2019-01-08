defmodule LazyContext do
  @moduledoc """
  LazyContext is a library that provides useful functions for accessing and
  creating data around an Ecto Schema.

  Generated functions:
  * `list_<examples>/0`
  * `get_<example>/1`
  * `get_<example>!/1`
  * `create_<example>/1`
  * `create_<example>!/1`
  * `create_or_update_<example>/1`
  * `create_or_update_<example>!/1`
  * `update_<example>/2`
  * `update_<example>!/2`
  * `delete_<example>/1`
  * `delete_<example>!/1`
  * `change_<example>/2`

  see `LazyContext.Examples.Users` for example generated functions with docs
  """

  @repo Application.get_env(:lazy_context, :repo)

  @type suffix() :: atom() | {atom(), atom()}

  @type preload_list() :: [atom()]
  @type preload_map() :: %{
    optional(:list) => preload_list(),
    optional(:get) => preload_list(),
    optional(:get!) => preload_list()
  }

  @type options() :: [
    schema: module(),
    suffix: suffix(),
    preloads: preload_list() | preload_map(),
    create_or_update_uniqueness_keys: [atom()]
  ]


  @doc """
  Inserts functions around an Ecto Schema. All inserted functions are overridable

  ## Options
  * `:schema` a module that implemented Ecto.Schema (`use Ecto.Schema`)
  * `:suffix` suffix to construct function names. If an atom is provided, an `s` is appended to name the `list_<examples>/0` function. Alternatively, a 2 atom tuple can be provided to specify the plural (e.g. `{:person, :people}`)
  * `:preloads` a list of fields to preload in `list`, `get` and `get!` functions.  Alternatively a map of function prefix to preload map can be provided to specify which function should preload which fields.
  * `:create_or_update_uniqueness_keys` list of keys used to identify an updateable item in `create_or_update_<example>`. Defaults to [:id]
  * `:repo` the Ecto Repo used to access the data - can be ommitted if repo was provided via config

  ## Examples
      use LazyContext,
        schema: User,
        suffix: :user

      use LazyContext,
        schema: Dog,
        suffix: :dog,
        preloads: %{
          get: [:owner]
          get!: [:owner]
        },
        create_or_update_uniqueness_keys: [:colour, :cuteness]
    
  """
  @spec __using__(options()) :: no_return()
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    {suffix, suffix_plural} =
      case Keyword.get(opts, :suffix) do
        {suffix, suffix_plural} -> {suffix, suffix_plural}
        suffix -> {suffix, "#{suffix}s"}
      end

    preloads = Keyword.get(opts, :preloads, [])
    repo = Keyword.get(opts, :repo) || @repo

    create_or_update_uniqueness_keys = Keyword.get(opts, :create_or_update_uniqueness_keys, [:id])

    f = %{
      list: :"list_#{suffix_plural}",
      get: :"get_#{suffix}",
      get!: :"get_#{suffix}!",
      create: :"create_#{suffix}",
      create!: :"create_#{suffix}!",
      create_or_update: :"create_or_update_#{suffix}",
      create_or_update!: :"create_or_update_#{suffix}!",
      update: :"update_#{suffix}",
      update!: :"update_#{suffix}!",
      delete: :"delete_#{suffix}",
      delete!: :"delete_#{suffix}!",
      change: :"change_#{suffix}",
      get_by_uniqueness_keys: :"get_by_uniqueness_keys_#{suffix}",
      get_preload_doc: :"get_preload_doc_#{suffix}"
    }

    overridables = [
      {f.list, 0},
      {f.get, 1},
      {f.get!, 1},
      {f.create, 1},
      {f.create!, 1},
      {f.create_or_update, 1},
      {f.create_or_update!, 1},
      {f.update, 2},
      {f.update!, 2},
      {f.delete, 1},
      {f.delete!, 1},
      {f.change, 2}
    ]

    quote do
      import LazyContext.Helpers

      @type unquote(suffix)() :: %unquote(schema){}
      @repo unquote(repo)

      @doc """
      Returns a list of `%#{unquote(schema)}{}` with `#{inspect get_preloads(:list, unquote(preloads))}` preloaded.

      ## Examples
          iex> list_#{unquote(suffix_plural)}()
          [%#{unquote(schema)}{}, ...]

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.list)() :: list(unquote(suffix)())
      def unquote(f.list)() do
        p = get_preloads(:list, unquote(preloads))

        unquote(schema)
        |> @repo.all()
        |> @repo.preload(p)
      end

      @doc """
      Gets a single `%#{unquote(schema)}{}` where all the given fields match, with `#{inspect get_preloads(:get, unquote(preloads))}` preloaded.

      Returns `nil` if no result was found.

      ## Examples
          iex> get_#{unquote(suffix)}(%{field1: "123", field2: 3, field4: true})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.get)(map()) :: list(unquote(suffix)()) | nil
      def unquote(f.get)(attrs) when is_map(attrs) do
        p = get_preloads(:get, unquote(preloads))

        unquote(schema)
        |> @repo.get_by(attrs)
        |> maybe_preload(p, @repo)
      end

      @doc """
      Gets a single `%#{unquote(schema)}{}` where the primary key matches the given ID, with `#{inspect get_preloads(:get, unquote(preloads))}` preloaded.

      Returns `nil` if no result was found. Raises if more than one result was found.

      ## Examples
          iex> get_#{unquote(suffix)}(123)
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.get)(integer()) :: list(unquote(suffix)()) | nil
      def unquote(f.get)(id) do
        p = get_preloads(:get, unquote(preloads))

        unquote(schema)
        |> @repo.get(id)
        |> maybe_preload(p, @repo)
      end

      @doc """
      Gets a single `%#{unquote(schema)}{}` where all the given fields match, with `#{inspect get_preloads(:get, unquote(preloads))}` preloaded.

      raises if no result was found.

      ## Examples
          iex> get_#{unquote(suffix)}(%{field1: "123", field2: 3, field4: true})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.get!)(map()) :: list(unquote(suffix)()) | no_return()
      def unquote(f.get!)(attrs) when is_map(attrs) do
        p = get_preloads(:get!, unquote(preloads))

        unquote(schema)
        |> @repo.get_by!(attrs)
        |> @repo.preload(p)
      end

      @doc """
      Gets a single `%#{unquote(schema)}{}` where the primary key matches the given ID, with `#{inspect get_preloads(:get, unquote(preloads))}` preloaded.

      Raises if no result, or more than one result was found.

      ## Examples
          iex> get_#{unquote(suffix)}(123)
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.get!)(integer()) :: list(unquote(suffix)()) | no_return()
      def unquote(f.get!)(id) do
        p = get_preloads(:get!, unquote(preloads))

        unquote(schema)
        |> @repo.get!(id)
        |> @repo.preload(p)
      end

      @doc """
      Creates an "empty" `%#{unquote(schema)}{}`, if valid. Equivalent to calling `create_#{unquote(suffix)}`(%{})

      ## Examples
          iex> create_#{unquote(suffix)}()
          {:ok, %#{unquote(schema)}{}}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create)() :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.create)(), do: unquote(f.create)(%{})

      @doc """
      Creates a `%#{unquote(schema)}{}`

      ## Examples
          iex> create_#{unquote(suffix)}(%{field: value})
          {:ok, %#{unquote(schema)}{}}
          iex> create_#{unquote(suffix)}(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create)(map()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.create)(attrs) do
        unquote(schema)
        |> struct()
        |> get_changeset(attrs, unquote(schema))
        |> @repo.insert()
      end

      @doc """
      Creates an "empty" `%#{unquote(schema)}{}`, if valid. Equivalent to calling `create_#{unquote(suffix)}!`(%{})

      Raises if the changeset is invalid.

      ## Examples
          iex> create_#{unquote(suffix)}!()
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create!)() :: unquote(suffix)() | no_return()
      def unquote(f.create!)(), do: unquote(:"create_#{suffix}!")(%{})

      @doc """
      Creates a `%#{unquote(schema)}{}`

      Raises if the changeset is invalid.

      ## Examples
          iex> create_#{unquote(suffix)}!(%{field: value})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create!)(map()) :: unquote(suffix)() | no_return()
      def unquote(f.create!)(attrs) do
        unquote(schema)
        |> struct()
        |> get_changeset(attrs, unquote(schema))
        |> @repo.insert!()
      end

      @doc """
      Updates a `%#{unquote(schema)}{}` if it already exists, otherwise creates one.

      Whether a `%#{unquote(schema)}{}` already exists is determined by a lookup on the following fields: #{inspect unquote(create_or_update_uniqueness_keys)}

      ## Examples
          iex> create_or_update#{unquote(suffix)}(%{field: value})
          {:ok, %#{unquote(schema)}{}}
          iex> create_#{unquote(suffix)}(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create_or_update)(map()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.create_or_update)(attrs) do
        case unquote(f.get_by_uniqueness_keys)(attrs) do
          nil -> unquote(f.create)(attrs)
          item -> unquote(f.update)(item, attrs)
        end
      end

      @doc """
      Updates a `%#{unquote(schema)}{}` if it already exists, otherwise creates one.

      Whether a `%#{unquote(schema)}{}` already exists is determined by a lookup on the following fields: #{inspect unquote(create_or_update_uniqueness_keys)}

      Raises if the changeset is invalid

      ## Examples
          iex> create_or_update#{unquote(suffix)}!(%{field: value})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create_or_update!)(map()) :: unquote(suffix)() | no_return()
      def unquote(f.create_or_update!)(attrs) do
        case unquote(f.get_by_uniqueness_keys)(attrs) do
          nil -> unquote(f.create!)(attrs)
          item -> unquote(f.update!)(item, attrs)
        end
      end

      @doc """
      Updates a `%#{unquote(schema)}{}`

      ## Examples
          iex> update_#{unquote(suffix)}(%#{unquote(schema)}{}, %{field: value})
          {:ok, %#{unquote(schema)}{}}
          iex> update_#{unquote(suffix)}(%#{unquote(schema)}{}, %{field: bad_value})
          {:error, %Ecto.Changeset{}}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.update)(unquote(suffix)(), map()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.update)(item, attrs) do
        item
        |> get_changeset(attrs, unquote(schema))
        |> @repo.update()
      end

      @doc """
      Updates a `%#{unquote(schema)}{}`

      Raises if the changeset is invalid

      ## Examples
          iex> update_#{unquote(suffix)}!(%#{unquote(schema)}{}, %{field: value})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.update!)(unquote(suffix)(), map()) :: unquote(suffix)() | no_return()
      def unquote(f.update!)(item, attrs) do
        item
        |> get_changeset(attrs, unquote(schema))
        |> @repo.update!()
      end

      @doc """
      deletes a `%#{unquote(schema)}{}`

      ## Examples
          iex> delete_#{unquote(suffix)}(%#{unquote(schema)}{})
          {:ok, %#{unquote(schema)}{}}
          iex> delete_#{unquote(suffix)}(%#{unquote(schema)}{})
          {:error, %Ecto.Changeset{}}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.delete)(unquote(suffix)()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.delete)(item) do
        item
        |> @repo.delete()
      end

      @doc """
      deletes a `%#{unquote(schema)}{}`

      Raises if deletion fails

      ## Examples
          iex> delete_#{unquote(suffix)}!(%#{unquote(schema)}{})
          %#{unquote(schema)}{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.delete!)(unquote(suffix)()) :: unquote(suffix) | no_return()
      def unquote(f.delete!)(item) do
        item
        |> @repo.delete!()
      end

      @doc """
      Returns a data structure for tracking `%#{unquote(schema)}{}` changes.

      ## Examples
          iex> change_#{unquote(suffix)}(%#{unquote(schema)}{}, %{field: value})
          %Ecto.Changeset{}

      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.change)(unquote(suffix)(), map()) :: Ecto.Changeset.t()
      def unquote(f.change)(item, attrs \\ %{}) do
        get_changeset(item, attrs, unquote(schema))
      end

      @spec unquote(f.get_by_uniqueness_keys)(map()) :: %unquote(schema){} | nil
      defp unquote(f.get_by_uniqueness_keys)(attrs) do
        get_attrs =
          attrs
          |> atomise_keys()
          |> Map.take(unquote(create_or_update_uniqueness_keys))
          |> Map.new()

        @repo.get_by(unquote(schema), get_attrs)
      end

      defoverridable unquote(overridables)
    end
  end
end
