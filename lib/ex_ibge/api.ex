defmodule ExIbge.Api do
  @base_url "https://servicodados.ibge.gov.br/api"
  @versions [:v1, :v2, :v3, :v4]

  @doc """
  Create a new client for a specific version of the API.
  """
  @type t :: Req.Request.t()

  @spec new!(atom()) :: t()
  def new!(version) when version in @versions do
    options = Application.get_env(:ex_ibge, :req_options, [])
    Req.new([base_url: "#{@base_url}/#{version}"] ++ options)
  end

  def new!(version) do
    raise ArgumentError, message: "Invalid version: #{version}"
  end

  @doc """
  Bangify a result.
  """
  @spec bangify({:ok, any()} | {:error, any()} | :ok) :: any()
  def bangify({:error, error}), do: raise(error)
  def bangify({:ok, body}), do: body
  def bangify(:ok), do: :ok
end
