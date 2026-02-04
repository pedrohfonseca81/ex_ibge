defmodule ExIbge.Locality.DistrictTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.District

  @district_fixture %{
    "id" => 160_030_312,
    "nome" => "Fazendinha",
    "municipio" => %{
      "id" => 1_600_303,
      "nome" => "Macapá",
      "microrregiao" => %{
        "id" => 16003,
        "nome" => "Macapá",
        "mesorregiao" => %{
          "id" => 1602,
          "nome" => "Sul do Amapá",
          "UF" => %{
            "id" => 16,
            "sigla" => "AP",
            "nome" => "Amapá",
            "regiao" => %{
              "id" => 1,
              "sigla" => "N",
              "nome" => "Norte"
            }
          }
        }
      },
      "regiao-imediata" => %{
        "id" => 160_001,
        "nome" => "Macapá",
        "regiao-intermediaria" => %{
          "id" => 1601,
          "nome" => "Macapá",
          "UF" => %{
            "id" => 16,
            "sigla" => "AP",
            "nome" => "Amapá",
            "regiao" => %{
              "id" => 1,
              "sigla" => "N",
              "nome" => "Norte"
            }
          }
        }
      }
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@district_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all districts" do
      assert {:ok, [district]} = District.all()
      assert district.id == 160_030_312
      assert district.name == "Fazendinha"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/distritos/160030312"
        Req.Test.json(conn, @district_fixture)
      end)

      assert {:ok, [district]} = District.find(160_030_312)
      assert district.id == 160_030_312
    end
  end

  describe "get_by_state/2" do
    test "gets by state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/16/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_state(16)
    end
  end

  describe "get_by_mesoregion/2" do
    test "gets by mesoregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/mesorregioes/123/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_mesoregion(123)
    end
  end

  describe "get_by_microregion/2" do
    test "gets by microregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/microrregioes/456/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_microregion(456)
    end
  end

  describe "get_by_municipality/2" do
    test "gets by municipality id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/municipios/789/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_municipality(789)
    end
  end

  describe "get_by_immediate_region/2" do
    test "gets by immediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-imediatas/111/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_immediate_region(111)
    end
  end

  describe "get_by_intermediate_region/2" do
    test "gets by intermediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-intermediarias/222/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_intermediate_region(222)
    end
  end

  describe "get_by_region/2" do
    test "gets by region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/1/distritos"
        Req.Test.json(conn, [@district_fixture])
      end)

      assert {:ok, _} = District.get_by_region(1)
    end
  end
end
