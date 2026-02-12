defmodule ExIbge.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ibge,
      version: "0.4.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: "https://github.com/pedrohfonseca81/ex_ibge"
    ]
  end

  defp description do
    "Cliente Elixir para a API de Localidades e Agregados do IBGE."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/pedrohfonseca81/ex_ibge"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5.0"},
      {:plug, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "guides/localidades.md",
        "guides/agregados.md",
        "guides/nomes.md",
        "CONTRIBUTING.md"
      ],
      format: [:html, :markdown, :epub],
      api_reference: [line_length: 120]
    ]
  end
end
