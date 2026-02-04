defmodule ExIbge.Locality.ImmediateRegionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.ImmediateRegion

  @immediate_region_fixture %{
    "id" => 330_001,
    "nome" => "Rio de Janeiro",
    "regiao-intermediaria" => %{
      "id" => 3301,
      "nome" => "Rio de Janeiro",
      "UF" => %{
        "id" => 33,
        "sigla" => "RJ",
        "nome" => "Rio de Janeiro",
        "regiao" => %{
          "id" => 3,
          "sigla" => "SE",
          "nome" => "Sudeste"
        }
      }
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@immediate_region_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all immediate regions" do
      assert {:ok, [region]} = ImmediateRegion.all()
      assert region.id == 330_001
      assert region.name == "Rio de Janeiro"
      assert region.intermediate_region.id == 3301
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-imediatas/330001"
        Req.Test.json(conn, @immediate_region_fixture)
      end)

      assert {:ok, [region]} = ImmediateRegion.find(330_001)
      assert region.id == 330_001
    end
  end

  describe "get_by_state/2" do
    test "returns immediate regions for a state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/33/regioes-imediatas"
        Req.Test.json(conn, [@immediate_region_fixture])
      end)

      assert {:ok, [region]} = ImmediateRegion.get_by_state(33)
      assert region.intermediate_region.state.id == 33
    end
  end

  describe "get_by_intermediate_region/2" do
    test "returns immediate regions for an intermediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path ==
                 "/api/v1/localidades/regioes-intermediarias/3301/regioes-imediatas"

        Req.Test.json(conn, [@immediate_region_fixture])
      end)

      assert {:ok, [region]} = ImmediateRegion.get_by_intermediate_region(3301)
      assert region.intermediate_region.id == 3301
    end
  end

  describe "get_by_region/2" do
    test "returns immediate regions for a region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/regioes-imediatas"
        Req.Test.json(conn, [@immediate_region_fixture])
      end)

      assert {:ok, [region]} = ImmediateRegion.get_by_region(3)
      assert region.intermediate_region.state.region.id == 3
    end
  end
end
