defmodule ExIbge.Locality.IntermediateRegion do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.IntermediateRegion

  @moduledoc """
  Module for handling Intermediate Region (Região Intermediária) queries from IBGE.

  This module provides functions to fetch Intermediate Regions by various geographical hierarchies
  (State, Region).
  """

  @doc """
  Get all intermediate regions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.all()
      {:ok, [%ExIbge.Geography.IntermediateRegion{id: 3301, name: "Rio de Janeiro", ...}, ...]}

  ## See Also

  [IBGE API: Regiões Intermediárias](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_intermediarias-regioes-intermediariasGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(IntermediateRegion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-intermediarias",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.all!()
      [%ExIbge.Geography.IntermediateRegion{id: 3301, name: "Rio de Janeiro", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(IntermediateRegion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get intermediate region(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.find(3301)
      {:ok, [%ExIbge.Geography.IntermediateRegion{id: 3301, name: "Rio de Janeiro", ...}]}

  ## See Also

  [IBGE API: Região Intermediária por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_intermediarias-regioes-intermediariasRegiaoIntermediariaGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(IntermediateRegion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-intermediarias/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.find!(3301)
      [%ExIbge.Geography.IntermediateRegion{id: 3301, name: "Rio de Janeiro", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(IntermediateRegion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get intermediate regions by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.get_by_state(33)
      {:ok, [%ExIbge.Geography.IntermediateRegion{...}, ...]}

      iex> ExIbge.Locality.IntermediateRegion.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.IntermediateRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Intermediárias por UF](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_intermediarias-estadosUFRegioesIntermediariasGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(IntermediateRegion.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/regioes-intermediarias",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.get_by_state!(33)
      [%ExIbge.Geography.IntermediateRegion{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(IntermediateRegion.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get intermediate regions by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.get_by_region(3)
      {:ok, [%ExIbge.Geography.IntermediateRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Intermediárias por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_intermediarias-regioesMacrorregiaoRegioesIntermediariasGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(IntermediateRegion.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/regioes-intermediarias",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntermediateRegion.get_by_region!(3)
      [%ExIbge.Geography.IntermediateRegion{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(IntermediateRegion.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    regions = Enum.map(data, &IntermediateRegion.from_map/1)
    {:ok, regions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [IntermediateRegion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
