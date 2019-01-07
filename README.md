# LazyContext

This library enables you to implement default functions in Phoenix contexts

See [Usage](#usage) for example usage.

## Documentation

Documentation is available at [https://hexdocs.pm/lazy_context](https://hexdocs.pm/lazy_context)

## Installation

Add `:lazy_context` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lazy_context, "~> 0.1.2-dev"}
  ]
end
```

## Configuration

Optionally set the repo for LazyContext config in your `config/config.exs` file:

```elixir
config :lazy_context,
  repo: YourApplication.Repo
```

## Usage

```elixir
defmodule MyApp.Users do
  @moduledoc """
  The Accounts context.
  """

  use LazyContext,
    schema: User,
    suffix: :user,
    # this can be omitted if the repo was set in the context
    repo: MyApp.Repo,
    preloads: [:pets]

  # functions can be overridden
  def list_users() do
    # custom code here
  end
end
```

## TODO

- [x] Tests
- [ ] Improve README
- [x] Generate documentation
- [x] Publish on hex.pm
- [x] Allow custom pluralized function names
- [ ] Improve error handling if `repo` or other mandatory options not provided
