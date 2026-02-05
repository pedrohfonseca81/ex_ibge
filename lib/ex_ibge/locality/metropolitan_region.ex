defmodule ExIbge.Locality.MetropolitanRegion do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Query
  alias ExIbge.Geography.MetropolitanRegion

  @moduledoc """
  Module for handling Metropolitan Region (Região Metropolitana) queries from IBGE.

  This module provides functions to fetch Metropolitan Regions by various geographical hierarchies
  (State, Region).
  """

  @doc """
  Get all metropolitan regions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: :name`, `municipality: 4204202`).

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.all()
      {:ok, [%ExIbge.Geography.MetropolitanRegion{id: 3301, name: "Rio de Janeiro", ...}, ...]}

  ## See Also

  [IBGE API: Regiões Metropolitanas](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_metropolitanas-regioes-metropolitanasGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(MetropolitanRegion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-metropolitanas",
      params: Query.build(query, Geography.MetropolitanRegion)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.all!()
      [%ExIbge.Geography.MetropolitanRegion{id: 3301, name: "Rio de Janeiro", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(MetropolitanRegion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get metropolitan region(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.find(3301)
      {:ok, [%ExIbge.Geography.MetropolitanRegion{id: 3301, name: "Rio de Janeiro", ...}]}

  ## See Also

  [IBGE API: Região Metropolitana por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_metropolitanas-regioes-metropolitanasRegiaoMetropolitanaGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(MetropolitanRegion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-metropolitanas/#{ids}",
      params: Query.build(query, Geography.MetropolitanRegion)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.find!(3301)
      [%ExIbge.Geography.MetropolitanRegion{id: 3301, name: "Rio de Janeiro", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(MetropolitanRegion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get metropolitan regions by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.get_by_state(33)
      {:ok, [%ExIbge.Geography.MetropolitanRegion{...}, ...]}

      iex> ExIbge.Locality.MetropolitanRegion.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.MetropolitanRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Metropolitanas por UF](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_metropolitanas-estadosUFRegioesMetropolitanasGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(MetropolitanRegion.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/regioes-metropolitanas",
      params: Query.build(query, Geography.MetropolitanRegion)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.get_by_state!(33)
      [%ExIbge.Geography.MetropolitanRegion{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(MetropolitanRegion.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get metropolitan regions by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.get_by_region(3)
      {:ok, [%ExIbge.Geography.MetropolitanRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Metropolitanas por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_metropolitanas-regioesMacrorregiaoRegioesMetropolitanasGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(MetropolitanRegion.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/regioes-metropolitanas",
      params: Query.build(query, Geography.MetropolitanRegion)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.MetropolitanRegion.get_by_region!(3)
      [%ExIbge.Geography.MetropolitanRegion{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(MetropolitanRegion.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    regions = Enum.map(data, &MetropolitanRegion.from_map/1)
    {:ok, regions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [MetropolitanRegion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
