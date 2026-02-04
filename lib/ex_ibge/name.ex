defmodule ExIbge.Name do
  @moduledoc """
  Module for handling IBGE Names API (v2).

  Provides data about the frequency of Brazilian names by decade of birth,
  collected in the 2010 Census.

  > Note: The API does not support compound names (e.g., "Maria Luiza"),
  > only the first name and last surname were collected.
  """

  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Name.{Frequency, Ranking}

  @doc """
  Get the frequency of births by decade for the given name(s).

  ## Parameters

    * `names` - A single name or a list of names.
    * `query` - Optional parameters:
      * `sexo`: Filter by sex ("M" for male, "F" for female).
      * `group_by`: Group results by geographic level (only "UF" is valid). Only works with a single name.
      * `localidade`: Filter by locality ID (e.g., "BR", "33", "3300100").

  ## Examples

      iex> ExIbge.Name.frequency("joao")
      {:ok, [%ExIbge.Name.Frequency{name: "JOAO", ...}]}

      iex> ExIbge.Name.frequency(["joao", "maria"])
      {:ok, [%ExIbge.Name.Frequency{name: "JOAO", ...}, %ExIbge.Name.Frequency{name: "MARIA", ...}]}

      iex> ExIbge.Name.frequency("ariel", sexo: "F")
      {:ok, [%ExIbge.Name.Frequency{name: "ARIEL", sex: "F", ...}]}

      iex> ExIbge.Name.frequency("joao", group_by: "UF")
      {:ok, [%ExIbge.Name.Frequency{locality: "11", ...}, ...]}

  ## See Also

  [IBGE API: Nomes](https://servicodados.ibge.gov.br/api/docs/nomes)
  """
  @spec frequency(String.t() | list(String.t()), Keyword.t()) ::
          {:ok, list(Frequency.t())} | {:error, any()}
  def frequency(names, query \\ []) do
    names = join_names(names)

    Req.get(Api.new!(:v2),
      url: "/censos/nomes/#{names}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response(Frequency)
  end

  @doc """
  Same as `frequency/2`, but raises an error on failure.
  """
  @spec frequency!(String.t() | list(String.t()), Keyword.t()) :: list(Frequency.t())
  def frequency!(names, query \\ []) do
    Api.bangify(frequency(names, query))
  end

  @doc """
  Get the ranking of names by frequency of births.

  ## Parameters

    * `query` - Optional parameters:
      * `decada`: Filter by decade of birth (e.g., "1950", "1980").
      * `localidade`: Filter by locality ID (e.g., "BR", "33", "3300100").
      * `sexo`: Filter by sex ("M" for male, "F" for female).

  ## Examples

      iex> ExIbge.Name.ranking()
      {:ok, [%ExIbge.Name.Ranking{locality: "BR", ...}]}

      iex> ExIbge.Name.ranking(decada: "1950")
      {:ok, [%ExIbge.Name.Ranking{...}]}

      iex> ExIbge.Name.ranking(localidade: "33", sexo: "F")
      {:ok, [%ExIbge.Name.Ranking{locality: "33", sex: "F", ...}]}

  ## See Also

  [IBGE API: Ranking de Nomes](https://servicodados.ibge.gov.br/api/docs/nomes)
  """
  @spec ranking(Keyword.t()) :: {:ok, list(Ranking.t())} | {:error, any()}
  def ranking(query \\ []) do
    Req.get(Api.new!(:v2),
      url: "/censos/nomes/ranking",
      params: Utils.to_camel_case(query)
    )
    |> handle_response(Ranking)
  end

  @doc """
  Same as `ranking/1`, but raises an error on failure.
  """
  @spec ranking!(Keyword.t()) :: list(Ranking.t())
  def ranking!(query \\ []) do
    Api.bangify(ranking(query))
  end

  defp join_names(names) when is_list(names), do: Enum.join(names, "|")
  defp join_names(name) when is_binary(name), do: name

  defp handle_response({:ok, %{status: 200, body: data}}, schema) when is_list(data) do
    {:ok, Enum.map(data, &schema.from_map/1)}
  end

  defp handle_response({:ok, %{status: 200, body: data}}, schema) when is_map(data) do
    {:ok, [schema.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}, _schema) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}, _schema) do
    {:error, error}
  end
end
