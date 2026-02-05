defmodule ExIbge.Query do
  alias ExIbge.Utils

  @translations %{
    order_by: :orderBy
  }

  @reverse_translations Map.new(@translations, fn {k, v} -> {v, k} end)

  def translate_struct(struct, data) do
    translations = merge_translations(struct)

    Enum.map(data, &translate_param(&1, translations))
  end

  def build(query, schema \\ nil) do
    translate_struct(schema, query)
    |> Utils.to_camel_case()
  end

  def translate_param({key, value}, translations \\ @translations) do
    translated_key = Map.get(translations, key, key)

    translated_value =
      if is_binary(value) do
        try do
          atom_value = String.to_existing_atom(value)
          Map.get(translations, atom_value, value)
        rescue
          ArgumentError -> value
        end
      else
        Map.get(translations, value, value)
      end

    {translated_key, translated_value}
  end

  def translate_param_reverse({key, value}) do
    translated_key = Map.get(@reverse_translations, key, key)
    translated_value = Map.get(@reverse_translations, value, value)
    {translated_key, translated_value}
  end

  defp merge_translations(nil), do: @translations

  defp merge_translations(schema) do
    if Code.ensure_loaded?(schema) and function_exported?(schema, :param_mappings, 0) do
      Map.merge(@translations, schema.param_mappings())
    else
      @translations
    end
  end
end
