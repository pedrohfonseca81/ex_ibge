defmodule ExIbge.BngbTest do
  use ExUnit.Case, async: true
  alias ExIbge.Bngb

  @feature_fixture %{
    "type" => "Feature",
    "properties" => %{
      "idNomebngb" => 180_379,
      "nomeGeografico" => "Brasília",
      "geocodigo" => "5300108",
      "termoGenerico" => nil,
      "termoEspecifico" => "Brasília",
      "conectivo" => nil,
      "categoria" => "Limites e Localidades",
      "classe" => "municipio, cidade, capital",
      "escalaOcorrencia" => "1:250.000",
      "statusValidacao" => "S",
      "nivelValidacao" => "ESPECIALISTA",
      "latitude" => -15.793985,
      "longitude" => -47.882816,
      "latitudeGMS" => "15°47'38.349\"S",
      "longitudeGMS" => "47°52'58.135\"W",
      "dataValidacao" => "01-02-2019",
      "dataPublicacao" => "29-05-2023",
      "escalaOrigemGeometria" => "1:250.000",
      "sustentacaoValidacao" => nil,
      "geometrytype" => "POINT"
    },
    "geometry" => %{
      "type" => "Point",
      "coordinates" => [-47.882816315, -15.793985367]
    }
  }

  @geojson_fixture %{
    "type" => "FeatureCollection",
    "crs" => %{"type" => "name", "properties" => %{"name" => "urn:ogc:def:crs:EPSG::4674"}},
    "features" => [@feature_fixture]
  }

  @category_fixture %{"categoria" => "Hidrografia"}

  @class_fixture %{
    "classe" => "ilha",
    "descricao_edgv" => "Porção de terra emersa.",
    "categoria" => "Hidrografia"
  }

  @dictionary_fixture %{
    "latitude" => %{"label_en" => nil, "label_es" => nil, "label_pt" => "Latitude"},
    "Hidrografia" => %{
      "label_en" => "Hidrography",
      "label_es" => nil,
      "label_pt" => "Hidrografia"
    }
  }

  @geo_name_fixture %{"termo" => "Rio Amazonas"}

  describe "get/1" do
    test "returns geographic name by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/nomegeografico/180379"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [geo]} = Bngb.get(180_379)
      assert geo.id == 180_379
      assert geo.name == "Brasília"
      assert geo.geocode == "5300108"
      assert geo.category == "Limites e Localidades"
      assert geo.latitude == -15.793985
      assert geo.geometry["type"] == "Point"
    end
  end

  describe "search/1" do
    test "returns geographic names matching pattern" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path =~ "/api/v1/bngb/padrao/"
        assert conn.request_path =~ "/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [geo]} = Bngb.search("brasilia")
      assert geo.name == "Brasília"
    end
  end

  describe "by_municipality/1" do
    test "returns geographic names for a municipality" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/municipio/5300108/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [geo]} = Bngb.by_municipality("5300108")
      assert geo.name == "Brasília"
    end
  end

  describe "by_state/1" do
    test "returns geographic names for a state string" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/uf/DF/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [_geo]} = Bngb.by_state("DF")
    end

    test "accepts atom for state" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/uf/DF/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [_geo]} = Bngb.by_state(:df)
    end
  end

  describe "by_proximity/3" do
    test "returns geographic names near coordinates" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/proximidade/-15.79/-47.88/10/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [_geo]} = Bngb.by_proximity(-15.79, -47.88, 10)
    end
  end

  describe "by_bounding_box/4" do
    test "returns geographic names within bounding box" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path ==
                 "/api/v1/bngb/enquadramento/-48.0/-16.0/-47.0/-15.0/nomesgeograficos"

        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [_geo]} = Bngb.by_bounding_box(-48.0, -16.0, -47.0, -15.0)
    end
  end

  describe "by_category/1" do
    test "returns geographic names for a category" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path =~ "/api/v1/bngb/categoria/"
        assert conn.request_path =~ "/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [geo]} = Bngb.by_category("Hidrografia")
      assert geo.name == "Brasília"
    end
  end

  describe "by_class/1" do
    test "returns geographic names for a class" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path =~ "/api/v1/bngb/classe/"
        assert conn.request_path =~ "/nomesgeograficos"
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert {:ok, [_geo]} = Bngb.by_class("ilha")
    end
  end

  describe "categories/0" do
    test "returns list of categories" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/listacategoria"
        Req.Test.json(conn, [@category_fixture])
      end)

      assert {:ok, [cat]} = Bngb.categories()
      assert cat.name == "Hidrografia"
    end
  end

  describe "classes/0" do
    test "returns list of classes" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/listaclasse"
        Req.Test.json(conn, [@class_fixture])
      end)

      assert {:ok, [cls]} = Bngb.classes()
      assert cls.name == "ilha"
      assert cls.description == "Porção de terra emersa."
      assert cls.category == "Hidrografia"
    end
  end

  describe "dictionary/0" do
    test "returns dictionary entries" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/dicionario"
        Req.Test.json(conn, @dictionary_fixture)
      end)

      assert {:ok, entries} = Bngb.dictionary()
      assert length(entries) == 2
      hidro = Enum.find(entries, &(&1.term == "Hidrografia"))
      assert hidro.label_en == "Hidrography"
      assert hidro.label_pt == "Hidrografia"
    end
  end

  describe "geo_names/0" do
    test "returns list of geographic names" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/bngb/listanomegeo"
        Req.Test.json(conn, [@geo_name_fixture])
      end)

      assert {:ok, [gn]} = Bngb.geo_names()
      assert gn.term == "Rio Amazonas"
    end
  end

  describe "bang functions" do
    test "get!/1 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @geojson_fixture)
      end)

      assert [%ExIbge.Bngb.GeographicName{}] = Bngb.get!(180_379)
    end

    test "categories!/0 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@category_fixture])
      end)

      assert [%ExIbge.Bngb.Category{}] = Bngb.categories!()
    end

    test "classes!/0 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@class_fixture])
      end)

      assert [%ExIbge.Bngb.Class{}] = Bngb.classes!()
    end

    test "dictionary!/0 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @dictionary_fixture)
      end)

      assert [%ExIbge.Bngb.DictionaryEntry{} | _] = Bngb.dictionary!()
    end

    test "geo_names!/0 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@geo_name_fixture])
      end)

      assert [%ExIbge.Bngb.GeoName{}] = Bngb.geo_names!()
    end
  end

  describe "error handling" do
    test "returns error tuple on HTTP error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Plug.Conn.send_resp(conn, 404, "")
      end)

      assert {:error, {:http_error, 404}} = Bngb.get(999_999)
    end
  end
end
