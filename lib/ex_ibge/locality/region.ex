defmodule ExIbge.Locality.Region do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Query
  alias ExIbge.Geography.Region

  @moduledoc """
  Module for handling Region (Macrorregião) queries from IBGE.

  This module provides functions to fetch Regions (Norte, Nordeste, Sudeste, Sul, Centro-Oeste).
  """

  @doc """
  Get all regions (Macrorregiões).

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: :name`).

  ## Examples

      iex> ExIbge.Locality.Region.all()
      {:ok, [%ExIbge.Geography.Region{id: 3, acronym: "SE", name: "Sudeste"}, ...]}

  ## See Also

  [IBGE API: Regiões](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes-regioesGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Region.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/regioes",
      params: Query.build(query, Geography.Region)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  Params and options are the same as `all/1`.

  ## Examples

      iex> ExIbge.Locality.Region.all!()
      [%ExIbge.Geography.Region{id: 3, acronym: "SE", name: "Sudeste"}, ...]
  """
  @spec all!(Keyword.t()) :: list(Region.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get region(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      # Get a single region
      iex> ExIbge.Locality.Region.find(3)
      {:ok, [%ExIbge.Geography.Region{id: 3, acronym: "SE", name: "Sudeste"}]}

      # Get multiple regions
      iex> ExIbge.Locality.Region.find([3, 4])
      {:ok, [%ExIbge.Geography.Region{id: 3, ...}, %ExIbge.Geography.Region{id: 4, ...}]}

  ## See Also

  [IBGE API: Região por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes-regioesMacrorregiaoGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Region.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}",
      params: Query.build(query, Geography.Region)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  Params and options are the same as `find/2`.

  ## Examples

      iex> ExIbge.Locality.Region.find!(3)
      [%ExIbge.Geography.Region{id: 3, acronym: "SE", name: "Sudeste"}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Region.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    regions = Enum.map(data, &Region.from_map/1)
    {:ok, regions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [Region.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
