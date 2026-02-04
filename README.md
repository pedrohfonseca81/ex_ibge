# ExIbge

**ExIbge** é um cliente Elixir amigável e moderno para a API de Localidades do IBGE.  
Desenvolvido para ser simples e fácil de integrar em qualquer projeto Elixir.

[![Hex.pm](https://img.shields.io/hexpm/v/ex_ibge.svg)](https://hex.pm/packages/ex_ibge)
[![Docs](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/ex_ibge/0.1.0)

## Instalação

Adicione `ex_ibge` à sua lista de dependências no `mix.exs`:

```elixir
def deps do
  [
    {:ex_ibge, "~> 0.1.0"}
  ]
end
```

## Como Usar

A biblioteca facilita a busca por municípios permitindo o uso de **atoms** (como `:sp`, `:rj`) para identificar estados, além de suportar filtros nativos da API.

### Buscando Municípios

```elixir
alias ExIbge.Locality.Municipality

# Buscar um município pelo ID
iex> [sp] = Municipality.find(3550308)
%ExIbge.Geography.Municipality{
  id: 3550308,
  name: "São Paulo",
  microregion: %ExIbge.Geography.Microregion{id: 35052, name: "São Paulo"},
  immediate_region: %ExIbge.Geography.ImmediateRegion{id: 35001, name: "São Paulo"}
}

# Buscar municípios ordenados por nome
iex> {:ok, ordenados} = Municipality.all(order_by: "nome")
[
  %ExIbge.Geography.Municipality{
    id: 3550308,
    name: "São Paulo",
    microregion: %ExIbge.Geography.Microregion{id: 35052, name: "São Paulo"},
    immediate_region: %ExIbge.Geography.ImmediateRegion{id: 35001, name: "São Paulo"}
  },
  ...
]

```

### Estruturas de Dados

Os retornos são structs Elixir devidamente mapeadas, facilitando o pattern matching:

```elixir
%ExIbge.Geography.Municipality{
  id: 3550308,
  name: "São Paulo",
  microregion: %ExIbge.Geography.Microregion{...},
  immediate_region: %ExIbge.Geography.ImmediateRegion{...}
}
```

---

## Próximos Passos

Abaixo estão os módulos e APIs do serviço de Localidades do IBGE que ainda precisam ser implementados:

### Localidade

- [x] **Municípios** (`ExIbge.Locality.Municipality`)
- [x] **Estados/UFs** (`ExIbge.Locality.State`)
- [x] **Macrorregiões** (`ExIbge.Locality.Region`)
- [x] **Mesorregiões** (`ExIbge.Locality.Mesoregion`)
- [x] **Microrregiões** (`ExIbge.Locality.Microregion`)
- [x] **Regiões Imediatas** (`ExIbge.Locality.ImmediateRegion`)
- [x] **Regiões Intermediárias** (`ExIbge.Locality.IntermediateRegion`)
- [x] **Distritos** (`ExIbge.Locality.District`)
- [x] **Subdistritos** (`ExIbge.Locality.Subdistrict`)
- [x] **Paises** (`ExIbge.Locality.Country`)
- [x] **Aglomeração Urbana** (`ExIbge.Locality.UrbanAgglomeration`)
- [x] **Regiões Metropolitanas** (`ExIbge.Locality.MetropolitanRegion`)
- [x] **Regiões Integradas de Desenvolvimento** (`ExIbge.Locality.IntegratedDevelopmentRegion`)

### Outros Módulos

- [x] **Agregados** (Análise multidimensional)
- [ ] **Banco de Dados Geodésicos** (Estações geodésicas)
- [ ] **BNGB** (Banco de Nomes Geográficos do Brasil)
- [ ] **Calendário** (Cronograma de ações e publicações)
- [ ] **CNAE** (Classificação Nacional de Atividades Econômicas)
- [ ] **hgeoHNOR** (Conversão de altitudes)
- [ ] **Malhas Geográficas** (Malhas e formatos diversos)
- [ ] **Metadados** (Metadados de pesquisas)
- [x] **Nomes** (Nomes mais comuns no Brasil)
- [ ] **Notícias** (Agência IBGE Notícias)
- [ ] **Países** (Indicadores socioeconômicos globais)
- [ ] **Pesquisas** (Dados do Censo, Brasil Cidades, etc.)
- [ ] **PPP** (Posicionamento por Ponto Preciso - Dados GNSS)
- [ ] **Produtos** (Produtos de estatística e geociências)
- [ ] **ProGriD** (Transformação de coordenadas)
- [ ] **Publicações** (Biblioteca do IBGE)
- [ ] **RBMC** (Rede Brasileira de Monitoramento Contínuo)
- [ ] **RMPG** (Rede Maregráfica Permanente para Geodésia)


## Contribuindo

Contribuições são muito bem-vindas! Seja corrigindo bugs, adicionando novas funcionalidades ou melhorando a documentação.

Para detalhes sobre como colaborar, por favor leia nosso [Guia de Contribuição](CONTRIBUTING.md).

Sinta-se livre para abrir PRs implementando qualquer um dos itens do To-Do acima!


