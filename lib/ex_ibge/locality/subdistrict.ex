defmodule ExIbge.Locality.Subdistrict do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Query
  alias ExIbge.Geography.Subdistrict

  @moduledoc """
  Module for handling Subdistrict (Subdistrito) queries from IBGE.

  This module provides functions to fetch Subdistricts by various geographical hierarchies
  (District, Municipality, State, etc.).
  """

  @doc """
  Get all subdistricts.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: :name`).

  ## Examples

      iex> ExIbge.Locality.Subdistrict.all()
      {:ok, [%ExIbge.Geography.Subdistrict{id: 53001080517, name: "Brasília", ...}, ...]}

  ## See Also

  [IBGE API: Subdistritos](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-subdistritosGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Subdistrict.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.all!()
      [%ExIbge.Geography.Subdistrict{id: 53001080517, name: "Brasília", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(Subdistrict.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get subdistrict(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.find(53001080517)
      {:ok, [%ExIbge.Geography.Subdistrict{id: 53001080517, name: "Brasília", ...}]}

  ## See Also

  [IBGE API: Subdistrito por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-subdistritosIdGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Subdistrict.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/subdistritos/#{ids}",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.find!(53001080517)
      [%ExIbge.Geography.Subdistrict{id: 53001080517, name: "Brasília", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Subdistrict.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get subdistricts by district identifier(s).

  ## Parameters

    * `district_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_district(530010805)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Distrito](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-distritosDistritoSubdistritosGet)
  """
  @spec get_by_district(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_district(district_ids, query \\ []) do
    ids = Utils.join_ids(district_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/distritos/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_district/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_district!(530010805)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_district!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Subdistrict.t())
  def get_by_district!(district_ids, query \\ []) do
    Api.bangify(get_by_district(district_ids, query))
  end

  @doc """
  Get subdistricts by municipality identifier(s).

  ## Parameters

    * `municipality_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_municipality(5300108)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Município](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-municipiosMunicipioSubdistritosGet)
  """
  @spec get_by_municipality(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_municipality(municipality_ids, query \\ []) do
    ids = Utils.join_ids(municipality_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/municipios/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_municipality/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_municipality!(5300108)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_municipality!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(Subdistrict.t())
  def get_by_municipality!(municipality_ids, query \\ []) do
    Api.bangify(get_by_municipality(municipality_ids, query))
  end

  @doc """
  Get subdistricts by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_state(53)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por UF](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-estadosUFSubdistritosGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_state!(53)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(Subdistrict.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get subdistricts by mesoregion identifier(s).

  ## Parameters

    * `mesoregion_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_mesoregion(5301)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Mesorregião](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-mesorregioesMesorregiaoSubdistritosGet)
  """
  @spec get_by_mesoregion(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_mesoregion(mesoregion_ids, query \\ []) do
    ids = Utils.join_ids(mesoregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/mesorregioes/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_mesoregion/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_mesoregion!(5301)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_mesoregion!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(Subdistrict.t())
  def get_by_mesoregion!(mesoregion_ids, query \\ []) do
    Api.bangify(get_by_mesoregion(mesoregion_ids, query))
  end

  @doc """
  Get subdistricts by microregion identifier(s).

  ## Parameters

    * `microregion_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_microregion(53001)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Microrregião](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-microrregioesMicrorregiaoSubdistritosGet)
  """
  @spec get_by_microregion(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_microregion(microregion_ids, query \\ []) do
    ids = Utils.join_ids(microregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/microrregioes/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_microregion/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_microregion!(53001)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_microregion!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(Subdistrict.t())
  def get_by_microregion!(microregion_ids, query \\ []) do
    Api.bangify(get_by_microregion(microregion_ids, query))
  end

  @doc """
  Get subdistricts by immediate region identifier(s).

  ## Parameters

    * `immediate_region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_immediate_region(530001)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Região Imediata](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-regioes_imediatasRegiaoImediataSubdistritosGet)
  """
  @spec get_by_immediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_immediate_region(immediate_region_ids, query \\ []) do
    ids = Utils.join_ids(immediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-imediatas/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_immediate_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_immediate_region!(530001)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_immediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(Subdistrict.t())
  def get_by_immediate_region!(immediate_region_ids, query \\ []) do
    Api.bangify(get_by_immediate_region(immediate_region_ids, query))
  end

  @doc """
  Get subdistricts by region identifier(s).

  ## Parameters

    * `region_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_region(5)
      {:ok, [%ExIbge.Geography.Subdistrict{...}, ...]}

  ## See Also

  [IBGE API: Subdistritos por Região](https://servicodados.ibge.gov.br/api/docs/localidades#api-Subdistritos-regioesMacrorregiaoSubdistritosGet)
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Subdistrict.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/subdistritos",
      params: Query.build(query, Geography.Subdistrict)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Subdistrict.get_by_region!(5)
      [%ExIbge.Geography.Subdistrict{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Subdistrict.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    subdistricts = Enum.map(data, &Subdistrict.from_map/1)
    {:ok, subdistricts}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [Subdistrict.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
