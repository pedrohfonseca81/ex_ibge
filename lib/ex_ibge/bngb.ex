defmodule ExIbge.Bngb do
  @moduledoc """
  Module for handling IBGE BNGB API (v1) — Banco de Nomes Geográficos do Brasil.

  Provides access to geographic names, their locations, categories, and classes
  as maintained by IBGE's geographic names database.
  """

  alias ExIbge.Api

  alias ExIbge.Bngb.{
    GeographicName,
    Category,
    Class,
    DictionaryEntry,
    GeoName
  }

  @doc """
  Get a geographic name by its identifier.

  ## Parameters

    * `id` - The BNGB identifier of the geographic name.

  ## Examples

      iex> ExIbge.Bngb.get(180379)
      {:ok, [%ExIbge.Bngb.GeographicName{name: "Brasília", ...}]}

  ## See Also

  [IBGE API: Nome Geográfico](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-1)
  """
  @spec get(integer() | String.t()) :: {:ok, list(GeographicName.t())} | {:error, any()}
  def get(id) do
    Req.get(Api.new!(:v1), url: "/bngb/nomegeografico/#{id}")
    |> handle_geojson_response()
  end

  @doc """
  Same as `get/1`, but raises on failure.
  """
  @spec get!(integer() | String.t()) :: list(GeographicName.t())
  def get!(id), do: Api.bangify(get(id))

  @doc """
  Search geographic names by a pattern in the name.

  ## Parameters

    * `pattern` - The search pattern to match against geographic names.

  ## Examples

      iex> ExIbge.Bngb.search("brasilia")
      {:ok, [%ExIbge.Bngb.GeographicName{name: "Brasília", ...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por padrão](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-2)
  """
  @spec search(String.t()) :: {:ok, list(GeographicName.t())} | {:error, any()}
  def search(pattern) do
    Req.get(Api.new!(:v1), url: "/bngb/padrao/#{URI.encode(pattern)}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `search/1`, but raises on failure.
  """
  @spec search!(String.t()) :: list(GeographicName.t())
  def search!(pattern), do: Api.bangify(search(pattern))

  @doc """
  Get geographic names by municipality geocode.

  ## Parameters

    * `geocode` - The municipality geocode (e.g., "5300108" for Brasília).

  ## Examples

      iex> ExIbge.Bngb.by_municipality("5300108")
      {:ok, [%ExIbge.Bngb.GeographicName{...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por município](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-3)
  """
  @spec by_municipality(integer() | String.t()) ::
          {:ok, list(GeographicName.t())} | {:error, any()}
  def by_municipality(geocode) do
    Req.get(Api.new!(:v1), url: "/bngb/municipio/#{geocode}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_municipality/1`, but raises on failure.
  """
  @spec by_municipality!(integer() | String.t()) :: list(GeographicName.t())
  def by_municipality!(geocode), do: Api.bangify(by_municipality(geocode))

  @doc """
  Get geographic names by state (UF).

  ## Parameters

    * `state` - The state abbreviation as a string (e.g., "DF") or atom (e.g., `:df`).

  ## Examples

      iex> ExIbge.Bngb.by_state(:df)
      {:ok, [%ExIbge.Bngb.GeographicName{...}, ...]}

      iex> ExIbge.Bngb.by_state("RJ")
      {:ok, [%ExIbge.Bngb.GeographicName{...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por UF](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-4)
  """
  @spec by_state(atom() | String.t()) :: {:ok, list(GeographicName.t())} | {:error, any()}
  def by_state(state) when is_atom(state) do
    by_state(state |> Atom.to_string() |> String.upcase())
  end

  def by_state(state) do
    Req.get(Api.new!(:v1), url: "/bngb/uf/#{state}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_state/1`, but raises on failure.
  """
  @spec by_state!(atom() | String.t()) :: list(GeographicName.t())
  def by_state!(state), do: Api.bangify(by_state(state))

  @doc """
  Get geographic names near a coordinate within a given distance.

  ## Parameters

    * `lat` - Latitude of the reference point.
    * `lon` - Longitude of the reference point.
    * `km` - Search radius in kilometers.

  ## Examples

      iex> ExIbge.Bngb.by_proximity(-15.79, -47.88, 10)
      {:ok, [%ExIbge.Bngb.GeographicName{...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por proximidade](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-5)
  """
  @spec by_proximity(number(), number(), number()) ::
          {:ok, list(GeographicName.t())} | {:error, any()}
  def by_proximity(lat, lon, km) do
    Req.get(Api.new!(:v1), url: "/bngb/proximidade/#{lat}/#{lon}/#{km}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_proximity/3`, but raises on failure.
  """
  @spec by_proximity!(number(), number(), number()) :: list(GeographicName.t())
  def by_proximity!(lat, lon, km), do: Api.bangify(by_proximity(lat, lon, km))

  @doc """
  Get geographic names within a bounding box defined by four coordinates.

  ## Parameters

    * `lon_w` - Western longitude.
    * `lat_s` - Southern latitude.
    * `lon_e` - Eastern longitude.
    * `lat_n` - Northern latitude.

  ## Examples

      iex> ExIbge.Bngb.by_bounding_box(-48.0, -16.0, -47.0, -15.0)
      {:ok, [%ExIbge.Bngb.GeographicName{...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por enquadramento](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-6)
  """
  @spec by_bounding_box(number(), number(), number(), number()) ::
          {:ok, list(GeographicName.t())} | {:error, any()}
  def by_bounding_box(lon_w, lat_s, lon_e, lat_n) do
    Req.get(Api.new!(:v1),
      url: "/bngb/enquadramento/#{lon_w}/#{lat_s}/#{lon_e}/#{lat_n}/nomesgeograficos"
    )
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_bounding_box/4`, but raises on failure.
  """
  @spec by_bounding_box!(number(), number(), number(), number()) :: list(GeographicName.t())
  def by_bounding_box!(lon_w, lat_s, lon_e, lat_n),
    do: Api.bangify(by_bounding_box(lon_w, lat_s, lon_e, lat_n))

  @doc """
  Get geographic names belonging to a given category.

  ## Parameters

    * `category` - The category name (e.g., "Hidrografia", "Relevo").

  ## Examples

      iex> ExIbge.Bngb.by_category("Hidrografia")
      {:ok, [%ExIbge.Bngb.GeographicName{category: "Hidrografia", ...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por categoria](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-7)
  """
  @spec by_category(String.t()) :: {:ok, list(GeographicName.t())} | {:error, any()}
  def by_category(category) do
    Req.get(Api.new!(:v1), url: "/bngb/categoria/#{URI.encode(category)}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_category/1`, but raises on failure.
  """
  @spec by_category!(String.t()) :: list(GeographicName.t())
  def by_category!(category), do: Api.bangify(by_category(category))

  @doc """
  Get geographic names belonging to a given class.

  ## Parameters

    * `class` - The class name (e.g., "ilha", "curso_dagua").

  ## Examples

      iex> ExIbge.Bngb.by_class("ilha")
      {:ok, [%ExIbge.Bngb.GeographicName{class: "ilha", ...}, ...]}

  ## See Also

  [IBGE API: Nomes Geográficos por classe](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Nomes%20Geograficos-8)
  """
  @spec by_class(String.t()) :: {:ok, list(GeographicName.t())} | {:error, any()}
  def by_class(class) do
    Req.get(Api.new!(:v1), url: "/bngb/classe/#{URI.encode(class)}/nomesgeograficos")
    |> handle_geojson_response()
  end

  @doc """
  Same as `by_class/1`, but raises on failure.
  """
  @spec by_class!(String.t()) :: list(GeographicName.t())
  def by_class!(class), do: Api.bangify(by_class(class))

  @doc """
  Get the list of categories available in the BNGB (EDGV 3.0).

  ## Examples

      iex> ExIbge.Bngb.categories()
      {:ok, [%ExIbge.Bngb.Category{name: "Hidrografia"}, ...]}

  ## See Also

  [IBGE API: Lista de categorias](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Outros-listacategoria)
  """
  @spec categories() :: {:ok, list(Category.t())} | {:error, any()}
  def categories do
    Req.get(Api.new!(:v1), url: "/bngb/listacategoria")
    |> handle_list_response(Category)
  end

  @doc """
  Same as `categories/0`, but raises on failure.
  """
  @spec categories!() :: list(Category.t())
  def categories!, do: Api.bangify(categories())

  @doc """
  Get the list of classes available in the BNGB (EDGV 3.0).

  ## Examples

      iex> ExIbge.Bngb.classes()
      {:ok, [%ExIbge.Bngb.Class{name: "ilha", description: "...", category: "Hidrografia"}, ...]}

  ## See Also

  [IBGE API: Lista de classes](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Outros-listaclasse)
  """
  @spec classes() :: {:ok, list(Class.t())} | {:error, any()}
  def classes do
    Req.get(Api.new!(:v1), url: "/bngb/listaclasse")
    |> handle_list_response(Class)
  end

  @doc """
  Same as `classes/0`, but raises on failure.
  """
  @spec classes!() :: list(Class.t())
  def classes!, do: Api.bangify(classes())

  @doc """
  Get the dictionary of API terms with translations to English, Spanish, and Portuguese labels.

  ## Examples

      iex> ExIbge.Bngb.dictionary()
      {:ok, [%ExIbge.Bngb.DictionaryEntry{term: "Hidrografia", label_pt: "Hidrografia", ...}, ...]}

  ## See Also

  [IBGE API: Dicionário](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Outros-dicionario)
  """
  @spec dictionary() :: {:ok, list(DictionaryEntry.t())} | {:error, any()}
  def dictionary do
    Req.get(Api.new!(:v1), url: "/bngb/dicionario")
    |> handle_dictionary_response()
  end

  @doc """
  Same as `dictionary/0`, but raises on failure.
  """
  @spec dictionary!() :: list(DictionaryEntry.t())
  def dictionary!, do: Api.bangify(dictionary())

  @doc """
  Get the list of all geographic names in the BNGB.

  ## Examples

      iex> ExIbge.Bngb.geo_names()
      {:ok, [%ExIbge.Bngb.GeoName{term: "Rio Amazonas"}, ...]}

  ## See Also

  [IBGE API: Lista dos nomes geográficos](https://servicodados.ibge.gov.br/api/docs/bngb?versao=1#api-Outros-listanomegeo)
  """
  @spec geo_names() :: {:ok, list(GeoName.t())} | {:error, any()}
  def geo_names do
    Req.get(Api.new!(:v1), url: "/bngb/listanomegeo")
    |> handle_list_response(GeoName)
  end

  @doc """
  Same as `geo_names/0`, but raises on failure.
  """
  @spec geo_names!() :: list(GeoName.t())
  def geo_names!, do: Api.bangify(geo_names())

  # --- Private ---

  defp handle_geojson_response({:ok, %{status: 200, body: %{"features" => features}}})
       when is_list(features) do
    {:ok, Enum.map(features, &GeographicName.from_feature/1)}
  end

  defp handle_geojson_response({:ok, %{status: 200, body: %{"features" => _} = data}}) do
    {:ok, [GeographicName.from_feature(data)]}
  end

  defp handle_geojson_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_geojson_response({:error, error}) do
    {:error, error}
  end

  defp handle_list_response({:ok, %{status: 200, body: data}}, schema) when is_list(data) do
    {:ok, Enum.map(data, &schema.from_map/1)}
  end

  defp handle_list_response({:ok, %{status: status}}, _schema) do
    {:error, {:http_error, status}}
  end

  defp handle_list_response({:error, error}, _schema) do
    {:error, error}
  end

  defp handle_dictionary_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, Enum.map(data, &DictionaryEntry.from_entry/1)}
  end

  defp handle_dictionary_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_dictionary_response({:error, error}) do
    {:error, error}
  end
end
