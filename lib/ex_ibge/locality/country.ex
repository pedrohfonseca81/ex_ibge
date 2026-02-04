defmodule ExIbge.Locality.Country do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.Country

  @moduledoc """
  Module for handling Country (País) queries from IBGE.

  This module provides functions to fetch Countries.
  """

  @doc """
  Get all countries.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.Country.all()
      {:ok, [%ExIbge.Geography.Country{id: 76, name: "Brasil", ...}, ...]}

  ## See Also

  [IBGE API: Países](https://servicodados.ibge.gov.br/api/docs/localidades#api-Paises-paisesGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Country.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/paises",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Country.all!()
      [%ExIbge.Geography.Country{id: 76, name: "Brasil", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(Country.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get country(ies) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID (M49) or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.Country.find(76)
      {:ok, [%ExIbge.Geography.Country{id: 76, name: "Brasil", ...}]}

  ## See Also

  [IBGE API: País por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Paises-paisesPaisesGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(Country.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/paises/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Country.find!(76)
      [%ExIbge.Geography.Country{id: 76, name: "Brasil", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(Country.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    countries = Enum.map(data, &Country.from_map/1)
    {:ok, countries}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [Country.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
