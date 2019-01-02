defmodule LazyContext.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lazy_context,
      version: "0.1.0-dev",
      deps: deps(),
      elixir: "~> 1.5",

      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:wx]],

      # Docs
      name: "LazyContext",
      source_url: "https://github.com/madebymany/lazy_context",
      docs: [
        main: "LazyContext", # The main page in the docs
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LazyContext, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "This library wraps Ecto to provides default functions to access and store data."
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      maintainers: ["Kat Lynch"],
      links: %{"GitHub" => "https://github.com/madebymany/lazy_context"}
    ]
  end
end
