defmodule ExIbge.Locality.ImmediateRegion do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.ImmediateRegion

  @moduledoc """
  Module for handling Immediate Region (Região Imediata) queries from IBGE.

  This module provides functions to fetch Immediate Regions by various geographical hierarchies
  (State, Intermediate Region, Region).
  """

  @doc """
  Get all immediate regions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.all()
      {:ok, [%ExIbge.Geography.ImmediateRegion{id: 330001, name: "Rio de Janeiro", ...}, ...]}

  ## See Also

  [IBGE API: Regiões Imediatas](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_imediatas-regioes-imediatasGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(ImmediateRegion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-imediatas",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.all!()
      [%ExIbge.Geography.ImmediateRegion{id: 330001, name: "Rio de Janeiro", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(ImmediateRegion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get immediate region(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.find(330001)
      {:ok, [%ExIbge.Geography.ImmediateRegion{id: 330001, name: "Rio de Janeiro", ...}]}

  ## See Also

  [IBGE API: Região Imediata por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_imediatas-regioes-imediatasRegiaoImediataGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ImmediateRegion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-imediatas/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.find!(330001)
      [%ExIbge.Geography.ImmediateRegion{id: 330001, name: "Rio de Janeiro", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ImmediateRegion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get immediate regions by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_state(33)
      {:ok, [%ExIbge.Geography.ImmediateRegion{...}, ...]}

      iex> ExIbge.Locality.ImmediateRegion.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.ImmediateRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Imediatas por UF](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_imediatas-estadosUFRegioesImediatasGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(ImmediateRegion.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/regioes-imediatas",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_state!(33)
      [%ExIbge.Geography.ImmediateRegion{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(ImmediateRegion.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get immediate regions by intermediate region identifier(s).

  ## Parameters

    * `intermediate_region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_intermediate_region(3301)
      {:ok, [%ExIbge.Geography.ImmediateRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Imediatas por Região Intermediária](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_imediatas-regioes_intermediariasRegiaoIntermediariaRegioesImediatasGet)
  """
  @spec get_by_intermediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(ImmediateRegion.t())} | {:error, any()}
  def get_by_intermediate_region(intermediate_region_ids, query \\ []) do
    ids = Utils.join_ids(intermediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-intermediarias/#{ids}/regioes-imediatas",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_intermediate_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_intermediate_region!(3301)
      [%ExIbge.Geography.ImmediateRegion{...}, ...]
  """
  @spec get_by_intermediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(ImmediateRegion.t())
  def get_by_intermediate_region!(intermediate_region_ids, query \\ []) do
    Api.bangify(get_by_intermediate_region(intermediate_region_ids, query))
  end

  @doc """
  Get immediate regions by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_region(3)
      {:ok, [%ExIbge.Geography.ImmediateRegion{...}, ...]}

  ## See Also

  [IBGE API: Regiões Imediatas por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_imediatas-regioesMacrorregiaoRegioesImediatasGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ImmediateRegion.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/regioes-imediatas",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.ImmediateRegion.get_by_region!(3)
      [%ExIbge.Geography.ImmediateRegion{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ImmediateRegion.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    regions = Enum.map(data, &ImmediateRegion.from_map/1)
    {:ok, regions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [ImmediateRegion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
