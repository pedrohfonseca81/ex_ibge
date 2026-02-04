defmodule ExIbge.Locality.IntegratedDevelopmentRegion do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.IntegratedDevelopmentRegion

  @moduledoc """
  Module for handling Integrated Development Region (Região Integrada de Desenvolvimento - RIDE) queries from IBGE.

  This module provides functions to fetch Integrated Development Regions.
  """

  @doc """
  Get all integrated development regions.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`, `municipio: 2611101`).

  ## Examples

      iex> ExIbge.Locality.IntegratedDevelopmentRegion.all()
      {:ok, [%ExIbge.Geography.IntegratedDevelopmentRegion{id: "07801", name: "Região Integrada de Desenvolvimento do Distrito Federal e Entorno", ...}, ...]}

  ## See Also

  [IBGE API: Regiões Integradas de Desenvolvimento](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_integradas_de_desenvolvimento-regioes-integradas-de-desenvolvimentoGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(IntegratedDevelopmentRegion.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-integradas-de-desenvolvimento",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntegratedDevelopmentRegion.all!()
      [%ExIbge.Geography.IntegratedDevelopmentRegion{id: "07801", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(IntegratedDevelopmentRegion.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get integrated development region(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.IntegratedDevelopmentRegion.find("07801")
      {:ok, [%ExIbge.Geography.IntegratedDevelopmentRegion{id: "07801", ...}]}

  ## See Also

  [IBGE API: Região Integrada de Desenvolvimento por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Regioes_integradas_de_desenvolvimento-regioes-integradas-de-desenvolvimentoRegiaoIntegradaDeDesenvolvimentoGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(IntegratedDevelopmentRegion.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-integradas-de-desenvolvimento/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.IntegratedDevelopmentRegion.find!("07801")
      [%ExIbge.Geography.IntegratedDevelopmentRegion{id: "07801", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(IntegratedDevelopmentRegion.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    regions = Enum.map(data, &IntegratedDevelopmentRegion.from_map/1)
    {:ok, regions}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [IntegratedDevelopmentRegion.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
