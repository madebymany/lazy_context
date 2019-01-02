defmodule LazyContext.Helpers do
  @moduledoc false

  @spec get_changeset(term(), map(), module()) :: Ecto.Changeset.t()
  def get_changeset(item, attrs, schema) do
    schema.changeset(item, attrs)
  end

  @spec maybe_preload(nil | term(), list(), Ecto.Repo.t()) :: nil | term()
  def maybe_preload(nil, _preloads, _repo), do: nil
  def maybe_preload(item, preloads, repo), do: repo.preload(item, preloads)

  @spec get_preloads(atom(), nil | list() | map()) :: list()
  def get_preloads(_func, preloads) when is_nil(preloads), do: []
  def get_preloads(_func, preloads) when is_list(preloads), do: preloads

  def get_preloads(func, preloads) when is_map(preloads) do
    Map.get(preloads, func, [])
  end

  def atomise(list) when is_list(list) do
    Enum.map(list, &atomise(&1))
  end

  @spec atomise_keys(map()) :: map()
  def atomise_keys(map) when is_map(map) do
    for {key, val} <- map, into: %{} do
      case key do
        key when is_binary(key) ->
          {String.to_atom(key), val}

        key ->
          {key, val}
      end
    end
  end
end
