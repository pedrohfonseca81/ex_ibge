defmodule ExIbge.QueryTest do
  use ExUnit.Case
  alias ExIbge.Query

  test "build/2 translates values using schema mappings inclusive string values" do
    query = [order_by: :name]
    assert Query.build(query, ExIbge.Geography.Municipality) == [{"orderBy", :nome}]

    query_str = [order_by: "name"]
    assert Query.build(query_str, ExIbge.Geography.Municipality) == [{"orderBy", :nome}]
  end
end
