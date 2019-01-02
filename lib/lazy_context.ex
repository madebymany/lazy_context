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
      get_by_uniqueness_keys: :"get_by_uniqueness_keys_#{suffix}"
    }

    quote do
      import LazyContext.Helpers
      require LazyContext.Behaviour

      LazyContext.Behaviour.with_behaviour unquote(schema), unquote(f) do
        @repo unquote(repo)

        @doc """
        generated via the `LazyContext.__using__/1` macro.


        Returns the list of <%= unquote(schema_plural) %>.
        ## Examples
            iex> list_<%= unquote(schema_plural) %>()
            [%<%= unquote(schema) %>{}, ...]
        """
        @impl true
        def unquote(f.list)() do
          p = get_preloads(:list, unquote(preloads))

          unquote(schema)
          |> @repo.all()
          |> @repo.preload(p)
        end

        @doc """
        generated via the `LazyContext.__using__/1` macro.
        """
        @impl true
        def unquote(f.get)(attrs) when is_map(attrs) do
          p = get_preloads(:get, unquote(preloads))

          unquote(schema)
          |> @repo.get_by(attrs)
          |> maybe_preload(p, @repo)
        end

        @doc """
        generated via the `LazyContext.__using__/1` macro.
        """
        @impl true
        def unquote(f.get)(id) do
          p = get_preloads(:get, unquote(preloads))

          unquote(schema)
          |> @repo.get(id)
          |> maybe_preload(p, @repo)
        end

        @doc """
        generated via the `LazyContext.__using__/1` macro.
        """
        @impl true
        def unquote(f.get!)(attrs) when is_map(attrs) do
          p = get_preloads(:get!, unquote(preloads))

          unquote(schema)
          |> @repo.get_by!(attrs)
          |> @repo.preload(p)
        end

        @doc """
        generated via the `LazyContext.__using__/1` macro.
        """
        @impl true
        def unquote(f.get!)(id) do
          p = get_preloads(:get!, unquote(preloads))

          unquote(schema)
          |> @repo.get!(id)
          |> @repo.preload(p)
        end

        @doc """
        generated via the `LazyContext.__using__/1` macro.
        """
        @impl true
        def unquote(f.create)(), do: unquote(f.create)(%{})

        @impl true
        def unquote(f.create)(attrs) do
          unquote(schema)
          |> struct()
          |> get_changeset(attrs, unquote(schema))
          |> @repo.insert()
        end

        @impl true
        def unquote(f.create!)(), do: unquote(:"create_#{suffix}!")(%{})

        @impl true
        def unquote(f.create!)(attrs) do
          unquote(schema)
          |> struct()
          |> get_changeset(attrs, unquote(schema))
          |> @repo.insert!()
        end

        @impl true
        def unquote(f.create_or_update)(attrs) do
          case unquote(f.get_by_uniqueness_keys)(attrs) do
            nil -> unquote(f.create)(attrs)
            item -> unquote(f.update)(item, attrs)
          end
        end

        @impl true
        def unquote(f.create_or_update!)(attrs) do
          case unquote(f.get_by_uniqueness_keys)(attrs) do
            nil -> unquote(f.create!)(attrs)
            item -> unquote(f.update!)(item, attrs)
          end
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

        @impl true
        def unquote(f.update)(item, attrs) do
          item
          |> get_changeset(attrs, unquote(schema))
          |> @repo.update()
        end

        @impl true
        def unquote(f.update!)(item, attrs) do
          item
          |> get_changeset(attrs, unquote(schema))
          |> @repo.update!()
        end

        @impl true
        def unquote(f.delete)(item) do
          item
          |> @repo.delete()
        end

        @impl true
        def unquote(f.delete!)(item) do
          item
          |> @repo.delete!()
        end

        @impl true
        def unquote(f.change)(item, attrs \\ %{}) do
          get_changeset(item, attrs, unquote(schema))
        end
      end
    end
  end
end
