defmodule LazyContext do
  @moduledoc """
  LazyContext is a library that provides useful functions for accessing and
  creating data around an Ecto Schema.
  """

  @repo Application.get_env(:lazy_context, :repo)

  @doc """
  Inserts functions around an Ecto Schema.
  """
  @spec __using__(keyword()) :: no_return()
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
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create)() :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.create)(), do: unquote(f.create)(%{})

      @doc """
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
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.create!)() :: unquote(suffix)() | no_return()
      def unquote(f.create!)(), do: unquote(:"create_#{suffix}!")(%{})

      @doc """
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
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.update)(unquote(suffix)(), map()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.update)(item, attrs) do
        item
        |> get_changeset(attrs, unquote(schema))
        |> @repo.update()
      end

      @doc """
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.update!)(unquote(suffix)(), map()) :: unquote(suffix)() | no_return()
      def unquote(f.update!)(item, attrs) do
        item
        |> get_changeset(attrs, unquote(schema))
        |> @repo.update!()
      end

      @doc """
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.delete)(unquote(suffix)()) :: {:ok, unquote(suffix)()} | {:error, Ecto.Changeset.t()}
      def unquote(f.delete)(item) do
        item
        |> @repo.delete()
      end

      @doc """
      generated via the `LazyContext.__using__/1` macro.
      """
      @spec unquote(f.delete!)(unquote(suffix)()) :: unquote(suffix) | no_return()
      def unquote(f.delete!)(item) do
        item
        |> @repo.delete!()
      end

      @doc """
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

      @defoverridable unquote(overridables)
    end
  end
end
