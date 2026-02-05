defmodule ExIbge.Locality.Microregion do
  @moduledoc """
  Module for handling Microregion (Microrregião) queries from IBGE.

  Microregions are subdivisions of mesoregions, grouping municipalities with
  similar geographic and economic characteristics.

  > Note: Microregions were replaced by Immediate Geographic Regions in 2017,
  > but this API endpoint is still available for historical data.
  """

  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Query
  alias ExIbge.Geography.Microregion

  @doc """
  Get all microregions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: :name`).

  ## Examples

      iex> ExIbge.Locality.Microregion.all()
      {:ok, [%ExIbge.Geography.Microregion{id: 11001, name: "Ji-Paraná", ...}, ...]}

  ## See Also

  [IBGE API: Microrregiões](https://servicodados.ibge.gov.br/api/docs/localidades#api-Microrregioes-microrregioesGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Microregion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/microrregioes",
      params: Query.build(query, Geography.Microregion)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.
  """
  @spec all!(Keyword.t()) :: list(Microregion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get microregion(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Microregion.find(33007)
      {:ok, [%ExIbge.Geography.Microregion{id: 33007, name: "Nova Friburgo", ...}]}

  ## See Also

  [IBGE API: Microrregião por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Microrregioes-microrregioesIdGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Microregion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/microrregioes/#{ids}",
      params: Query.build(query, Geography.Microregion)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Microregion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get microregions by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Microregion.get_by_state(33)
      {:ok, [%ExIbge.Geography.Microregion{...}, ...]}

      iex> ExIbge.Locality.Microregion.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.Microregion{...}, ...]}

  ## See Also

  [IBGE API: Microrregiões por UF](https://servicodados.ibge.gov.br/api/docs/localidades#api-Microrregioes-estadosUFMicrorregioesGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) :: {:ok, list(Microregion.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/microrregioes",
      params: Query.build(query, Geography.Microregion)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) :: list(Microregion.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get microregions by mesoregion identifier(s).

  ## Parameters

    * `mesoregion_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Microregion.get_by_mesoregion(3303)
      {:ok, [%ExIbge.Geography.Microregion{...}, ...]}

  ## See Also

  [IBGE API: Microrregiões por Mesorregião](https://servicodados.ibge.gov.br/api/docs/localidades#api-Microrregioes-mesorregioesMesorregiaoMicrorregioesGet)
  """
  @spec get_by_mesoregion(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Microregion.t())} | {:error, any()}
  def get_by_mesoregion(mesoregion_ids, query \\ []) do
    ids = Utils.join_ids(mesoregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/mesorregioes/#{ids}/microrregioes",
      params: Query.build(query, Geography.Microregion)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_mesoregion/2`, but raises an error on failure.
  """
  @spec get_by_mesoregion!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Microregion.t())
  def get_by_mesoregion!(mesoregion_ids, query \\ []) do
    Api.bangify(get_by_mesoregion(mesoregion_ids, query))
  end

  @doc """
  Get microregions by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs (1-5).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Microregion.get_by_region(3)
      {:ok, [%ExIbge.Geography.Microregion{...}, ...]}

  ## See Also

  [IBGE API: Microrregiões por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Microrregioes-regioesRegiaoMicrorregioesGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Microregion.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/microrregioes",
      params: Query.build(query, Geography.Microregion)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Microregion.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    {:ok, Enum.map(data, &Microregion.from_map/1)}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [Microregion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
