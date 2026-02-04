defmodule ExIbge.Locality.State do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.State

  @moduledoc """
  Module for handling State (UF) queries from IBGE.

  This module provides functions to fetch States (e.g., São Paulo, Rio de Janeiro), covering the "Unidades da Federação".
  It supports querying by ID, acronym (atom), or region.
  """

  @doc """
  Get all states (UFs).

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.State.all()
      {:ok, [%ExIbge.Geography.State{id: 35, acronym: "SP", name: "São Paulo", ...}, ...]}

      iex> ExIbge.Locality.State.all(order_by: "nome")
      {:ok, [%ExIbge.Geography.State{id: 35, acronym: "SP", name: "São Paulo", ...}, ...]}

  ## See Also

  [IBGE API: Estados](https://servicodados.ibge.gov.br/api/docs/localidades#api-UFs-estadosGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(State.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1), url: "/localidades/estados", params: Utils.to_camel_case(query))
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  Params and options are the same as `all/1`.

  ## Examples

      iex> ExIbge.Locality.State.all!()
      [%ExIbge.Geography.State{id: 35, acronym: "SP", name: "São Paulo", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(State.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get state(s) by identifier(s).

  ## Parameters

    * `ids` - A single identifier or list of identifiers. Can be integer IDs (e.g. `35`) or atom acronyms (e.g. `:sp`).
    * `query` - Optional parameters supported by the API.

  ## Examples

      # Get by integer ID
      iex> ExIbge.Locality.State.find(35)
      {:ok, [%ExIbge.Geography.State{id: 35, acronym: "SP", ...}]}

      # Get by atom acronym
      iex> ExIbge.Locality.State.find(:sp)
      {:ok, [%ExIbge.Geography.State{id: 35, acronym: "SP", ...}]}

      # Get multiple states
      iex> ExIbge.Locality.State.find([33, 35])
      {:ok, [%ExIbge.Geography.State{id: 33, ...}, %ExIbge.Geography.State{id: 35, ...}]}

  ## See Also

  [IBGE API: Estado por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-UFs-estadosUFGet)
  """
  @spec find(integer() | atom() | String.t() | list(integer() | atom() | String.t()), Keyword.t()) ::
          {:ok, list(State.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  Params and options are the same as `find/2`.

  ## Examples

      iex> ExIbge.Locality.State.find!(35)
      [%ExIbge.Geography.State{id: 35, acronym: "SP", ...}]
  """
  @spec find!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(State.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get states by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or list of integer IDs representing the region(s).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.State.get_by_region(3)
      {:ok, [%ExIbge.Geography.State{id: 35, acronym: "SP", ...}, ...]}

  ## See Also

  [IBGE API: Estados por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-UFs-regioesMacrorregiaoEstadosGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(State.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/estados",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  Params and options are the same as `get_by_region/2`.

  ## Examples

      iex> ExIbge.Locality.State.get_by_region!(3)
      [%ExIbge.Geography.State{id: 35, acronym: "SP", ...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(State.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    states = Enum.map(data, &State.from_map/1)
    {:ok, states}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [State.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
