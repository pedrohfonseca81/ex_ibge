defmodule ExIbge.Locality.MunicipalityTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Municipality

  @municipality_fixture %{
    "id" => 3_550_308,
    "nome" => "São Paulo",
    "microrregiao" => %{
      "id" => 35061,
      "nome" => "São Paulo",
      "mesorregiao" => %{
        "id" => 3515,
        "nome" => "Metropolitana de São Paulo",
        "UF" => %{
          "id" => 35,
          "sigla" => "SP",
          "nome" => "São Paulo",
          "regiao" => %{
            "id" => 3,
            "sigla" => "SE",
            "nome" => "Sudeste"
          }
        }
      }
    },
    "regiao-imediata" => %{
      "id" => 350_001,
      "nome" => "São Paulo",
      "regiao-intermediaria" => %{
        "id" => 3501,
        "nome" => "São Paulo",
        "UF" => %{
          "id" => 35,
          "sigla" => "SP",
          "nome" => "São Paulo",
          "regiao" => %{
            "id" => 3,
            "sigla" => "SE",
            "nome" => "Sudeste"
          }
        }
      }
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@municipality_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all municipalities" do
      assert {:ok, [muni]} = Municipality.all()
      assert muni.id == 3_550_308
      assert muni.name == "São Paulo"
    end

    test "passes query params" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.query_string == "orderBy=nome"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.all(order_by: "nome")
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/municipios/3550308"
        # Single object return
        Req.Test.json(conn, @municipality_fixture)
      end)

      # API returns single object for find/1 sometimes, or list.
      # Utils handles map vs list. Our fixture in implementation was handling map wrapping.
      # Let's test single map response.
      assert {:ok, [muni]} = Municipality.find(3_550_308)
      assert muni.id == 3_550_308
    end

    test "finds by list of ids" do
      ids = [3_550_308, 3_304_557]

      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/municipios/3550308%7C3304557"
        Req.Test.json(conn, [@municipality_fixture, @municipality_fixture])
      end)

      assert {:ok, list} = Municipality.find(ids)
      assert length(list) == 2
    end
  end

  describe "get_by_state/2" do
    test "gets by state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_state(35)
    end

    test "gets by state atom" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_state(:sp)
    end

    test "gets by list of state atoms" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35%7C33/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_state([:sp, :rj])
    end
  end

  describe "get_by_mesoregion/2" do
    test "gets by mesoregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/mesorregioes/123/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_mesoregion(123)
    end
  end

  describe "get_by_microregion/2" do
    test "gets by microregion id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/microrregioes/456/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_microregion(456)
    end
  end

  describe "get_by_immediate_region/2" do
    test "gets by immediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-imediatas/789/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_immediate_region(789)
    end
  end

  describe "get_by_intermediate_region/2" do
    test "gets by intermediate region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-intermediarias/101/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_intermediate_region(101)
    end
  end

  describe "get_by_region/2" do
    test "gets by region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/municipios"
        Req.Test.json(conn, [@municipality_fixture])
      end)

      assert {:ok, _} = Municipality.get_by_region(3)
    end
  end

  describe "bang functions" do
    test "all! returns list" do
      assert [_] = Municipality.all!()
    end

    test "find! returns list" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @municipality_fixture)
      end)

      assert [_] = Municipality.find!(3_550_308)
    end

    test "raises on error" do
      Req.Test.stub(ExIbge.Api, fn _conn ->
        raise "oops"
      end)

      assert_raise RuntimeError, "oops", fn ->
        Municipality.all!()
      end
    end
  end
end
