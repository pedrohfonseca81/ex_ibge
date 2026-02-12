# Guia do BNGB (Banco de Nomes Geográficos do Brasil)

O módulo `ExIbge.Bngb` permite consultar nomes geográficos oficiais do Brasil, mantidos pelo IBGE. Os dados incluem coordenadas, categorias (EDGV 3.0) e metadados de validação.

## Conceitos

### Nome Geográfico
Um nome oficialmente atribuído a um acidente geográfico (rio, serra, cidade, ilha, etc). Cada nome tem coordenadas, categoria, classe e status de validação.

### Categorias e Classes
Os nomes são organizados segundo a EDGV 3.0:
- **Categoria**: agrupamento amplo (ex: "Hidrografia", "Relevo", "Limites e Localidades")
- **Classe**: tipo específico dentro da categoria (ex: "ilha", "curso_dagua", "município")

---

## Uso

### Buscar por ID

```elixir
ExIbge.Bngb.get!(180379)
# [%ExIbge.Bngb.GeographicName{
#   id: 180379,
#   name: "Brasília",
#   geocode: "5300108",
#   category: "Limites e Localidades",
#   latitude: -15.793985,
#   longitude: -47.882816,
#   ...
# }]
```

### Buscar por padrão no nome

```elixir
ExIbge.Bngb.search!("amazonas")
```

### Por estado (aceita atom)

```elixir
ExIbge.Bngb.by_state!(:df)
ExIbge.Bngb.by_state!("RJ")
```

### Por município (geocódigo)

```elixir
ExIbge.Bngb.by_municipality!("5300108")
```

### Por proximidade (latitude, longitude, raio em km)

```elixir
ExIbge.Bngb.by_proximity!(-15.79, -47.88, 10)
```

### Por enquadramento (bounding box)

```elixir
ExIbge.Bngb.by_bounding_box!(-48.0, -16.0, -47.0, -15.0)
```

### Por categoria ou classe

```elixir
ExIbge.Bngb.by_category!("Hidrografia")
ExIbge.Bngb.by_class!("ilha")
```

---

## Dados auxiliares

### Listar categorias e classes

```elixir
ExIbge.Bngb.categories!()
# [%ExIbge.Bngb.Category{name: "Hidrografia"}, ...]

ExIbge.Bngb.classes!()
# [%ExIbge.Bngb.Class{name: "ilha", description: "...", category: "Hidrografia"}, ...]
```

### Dicionário de termos

```elixir
ExIbge.Bngb.dictionary!()
# [%ExIbge.Bngb.DictionaryEntry{term: "Hidrografia", label_pt: "Hidrografia", label_en: "Hydrography", ...}, ...]
```

### Lista de nomes geográficos

```elixir
ExIbge.Bngb.geo_names!()
# [%ExIbge.Bngb.GeoName{term: "Rio Amazonas"}, ...]
```

---

## Dicas

* Todos os endpoints de nomes geográficos retornam dados GeoJSON convertidos para o struct `GeographicName`.
* Use `categories!/0` e `classes!/0` para descobrir os valores válidos antes de filtrar com `by_category!/1` e `by_class!/1`.
* A API retorna geometria (ponto, linha ou polígono) no campo `geometry` do struct.
