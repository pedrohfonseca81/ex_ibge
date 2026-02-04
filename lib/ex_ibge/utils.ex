defmodule ExIbge.Utils do
  @ufs %{
    ro: 11,
    ac: 12,
    am: 13,
    rr: 14,
    pa: 15,
    ap: 16,
    to: 17,
    ma: 21,
    pi: 22,
    ce: 23,
    rn: 24,
    pb: 25,
    pe: 26,
    al: 27,
    se: 28,
    ba: 29,
    mg: 31,
    es: 32,
    rj: 33,
    sp: 35,
    pr: 41,
    sc: 42,
    rs: 43,
    ms: 50,
    mt: 51,
    go: 52,
    df: 53
  }

  def join_ids(ids) when is_list(ids) do
    ids
    |> Enum.map(&resolve_id/1)
    |> Enum.join("|")
    |> URI.encode()
  end

  def join_ids(id), do: resolve_id(id) |> to_string()

  defp resolve_id(id) when is_atom(id), do: Map.get(@ufs, id, id)
  defp resolve_id(id), do: id

  def to_camel_case(params) when is_list(params) or is_map(params) do
    Enum.map(params, fn {key, value} ->
      {camelize(key), value}
    end)
  end

  defp camelize(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> camelize()
  end

  defp camelize(key) when is_binary(key) do
    key
    |> Macro.camelize()
    |> uncapitalize_local()
  end

  defp uncapitalize_local(<<first::utf8, rest::binary>>) do
    String.downcase(<<first::utf8>>) <> rest
  end

  defp uncapitalize_local(""), do: ""
end
