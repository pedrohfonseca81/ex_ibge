defmodule ExIbge.Locality.UrbanAgglomerationTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.UrbanAgglomeration

  @urban_agglomeration_fixture %{
    "id" => "00301",
    "nome" => "Aglomeração Urbana de Franca",
    "municipios" => []
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@urban_agglomeration_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all urban agglomerations" do
      assert {:ok, [agglomeration]} = UrbanAgglomeration.all()
      assert agglomeration.id == "00301"
      assert agglomeration.name == "Aglomeração Urbana de Franca"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/aglomeracoes-urbanas/00301"
        Req.Test.json(conn, @urban_agglomeration_fixture)
      end)

      assert {:ok, [agglomeration]} = UrbanAgglomeration.find("00301")
      assert agglomeration.id == "00301"
    end
  end
end
