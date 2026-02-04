defmodule ExIbge.Locality.Mesoregion do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.Mesoregion

  @moduledoc """
  Module for handling Mesoregion (Mesorregião) queries from IBGE.

  This module provides functions to fetch Mesoregions by various geographical hierarchies
  (State, Region).
  """

  @doc """
  Get all mesoregions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.Mesoregion.all()
      {:ok, [%ExIbge.Geography.Mesoregion{id: 3301, name: "Noroeste Fluminense", ...}, ...]}

  ## See Also

  [IBGE API: Mesorregiões](https://servicodados.ibge.gov.br/api/docs/localidades#api-Mesorregioes-mesorregioesGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Mesoregion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1), url: "/localidades/mesorregioes", params: Utils.to_camel_case(query))
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.all!()
      [%ExIbge.Geography.Mesoregion{id: 3301, name: "Noroeste Fluminense", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(Mesoregion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get mesoregion(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.find(3301)
      {:ok, [%ExIbge.Geography.Mesoregion{id: 3301, name: "Noroeste Fluminense", ...}]}

  ## See Also

  [IBGE API: Mesorregião por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Mesorregioes-mesorregioesMesorregiaoGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Mesoregion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/mesorregioes/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.find!(3301)
      [%ExIbge.Geography.Mesoregion{id: 3301, name: "Noroeste Fluminense", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Mesoregion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get mesoregions by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.get_by_state(33)
      {:ok, [%ExIbge.Geography.Mesoregion{...}, ...]}

      iex> ExIbge.Locality.Mesoregion.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.Mesoregion{...}, ...]}

  ## See Also

  [IBGE API: Mesorregiões por Estado](https://servicodados.ibge.gov.br/api/docs/localidades#api-Mesorregioes-estadosUFMesorregioesGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(Mesoregion.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/mesorregioes",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.get_by_state!(33)
      [%ExIbge.Geography.Mesoregion{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(Mesoregion.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get mesoregions by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.get_by_region(3)
      {:ok, [%ExIbge.Geography.Mesoregion{...}, ...]}

  ## See Also

  [IBGE API: Mesorregiões por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Mesorregioes-regioesMacrorregiaoMesorregioesGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Mesoregion.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/mesorregioes",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Mesoregion.get_by_region!(3)
      [%ExIbge.Geography.Mesoregion{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Mesoregion.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    mesoregions = Enum.map(data, &Mesoregion.from_map/1)
    {:ok, mesoregions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [Mesoregion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
