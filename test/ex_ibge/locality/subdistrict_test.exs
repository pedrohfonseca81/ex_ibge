defmodule ExIbge.Locality.SubdistrictTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Subdistrict

  @subdistrict_fixture %{
    "id" => 53_001_080_517,
    "nome" => "Brasília",
    "distrito" => %{
      "id" => 530_010_805,
      "nome" => "Brasília",
      "municipio" => %{
        "id" => 5_300_108,
        "nome" => "Brasília",
        "microrregiao" => %{
          "id" => 53001,
          "nome" => "Brasília",
          "mesorregiao" => %{
            "id" => 5301,
            "nome" => "Distrito Federal",
            "UF" => %{
              "id" => 53,
              "sigla" => "DF",
              "nome" => "Distrito Federal",
              "regiao" => %{
                "id" => 5,
                "sigla" => "CO",
                "nome" => "Centro-Oeste"
              }
            }
          }
        },
        "regiao-imediata" => %{
          "id" => 530_001,
          "nome" => "Distrito Federal",
          "regiao-intermediaria" => %{
            "id" => 5301,
            "nome" => "Distrito Federal",
            "UF" => %{
              "id" => 53,
              "sigla" => "DF",
              "nome" => "Distrito Federal",
              "regiao" => %{
                "id" => 5,
                "sigla" => "CO",
                "nome" => "Centro-Oeste"
              }
            }
          }
        }
      }
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@subdistrict_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all subdistricts" do
      assert {:ok, [subdistrict]} = Subdistrict.all()
      assert subdistrict.id == 53_001_080_517
      assert subdistrict.name == "Brasília"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/subdistritos/53001080517"
        Req.Test.json(conn, @subdistrict_fixture)
      end)

      assert {:ok, [subdistrict]} = Subdistrict.find(53_001_080_517)
      assert subdistrict.id == 53_001_080_517
    end
  end

  describe "get_by_district/2" do
    test "returns subdistricts for a district id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/distritos/530010805/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_district(530_010_805)
      assert subdistrict.district.id == 530_010_805
    end
  end

  describe "get_by_municipality/2" do
    test "returns subdistricts for a municipality id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/municipios/5300108/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_municipality(5_300_108)
      assert subdistrict.district.municipality.id == 5_300_108
    end
  end

  describe "get_by_state/2" do
    test "returns subdistricts for a state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/53/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_state(53)
      assert subdistrict.district.municipality.microregion.mesoregion.state.id == 53
    end
  end

  describe "get_by_mesoregion/2" do
    test "returns subdistricts for a mesoregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/mesorregioes/5301/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_mesoregion(5301)
      assert subdistrict.district.municipality.microregion.mesoregion.id == 5301
    end
  end

  describe "get_by_microregion/2" do
    test "returns subdistricts for a microregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/microrregioes/53001/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_microregion(53001)
      assert subdistrict.district.municipality.microregion.id == 53001
    end
  end

  describe "get_by_immediate_region/2" do
    test "returns subdistricts for an immediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-imediatas/530001/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_immediate_region(530_001)
      assert subdistrict.district.municipality.immediate_region.id == 530_001
    end
  end

  describe "get_by_region/2" do
    test "returns subdistricts for a region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/5/subdistritos"
        Req.Test.json(conn, [@subdistrict_fixture])
      end)

      assert {:ok, [subdistrict]} = Subdistrict.get_by_region(5)
      assert subdistrict.district.municipality.microregion.mesoregion.state.region.id == 5
    end
  end
end
