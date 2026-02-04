# ExIbge

**ExIbge** é um cliente Elixir amigável e moderno para a API de Localidades do IBGE.  
Desenvolvido para ser simples e fácil de integrar em qualquer projeto Elixir.

[![Hex.pm](https://img.shields.io/hexpm/v/ex_ibge.svg)](https://hex.pm/packages/ex_ibge)
[![Docs](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/ex_ibge/0.2.1)

## Instalação

Adicione `ex_ibge` à sua lista de dependências no `mix.exs`:

```elixir
def deps do
  [
    {:ex_ibge, "~> 0.2.1"}
  ]
end
```

## Como Usar

A biblioteca facilita a busca por municípios permitindo o uso de **atoms** (como `:sp`, `:rj`) para identificar estados, além de suportar filtros nativos da API.

### Buscando Municípios

```elixir
alias ExIbge.Locality.Municipality

# Buscar um município pelo ID
iex> Municipality.find(3550308)
%ExIbge.Geography.Municipality{
  id: 3550308,
  name: "São Paulo",
  microregion: %ExIbge.Geography.Microregion{id: 35052, name: "São Paulo"},
  immediate_region: %ExIbge.Geography.ImmediateRegion{id: 35001, name: "São Paulo"}
}

# Buscar municípios ordenados por nome
iex> Municipality.all(order_by: "nome")
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

## Funcionalidades

### Localidades
- **Municípios** (`ExIbge.Locality.Municipality`)
- **Estados/UFs** (`ExIbge.Locality.State`)
- **Macrorregiões** (`ExIbge.Locality.Region`)
- **Mesorregiões** (`ExIbge.Locality.Mesoregion`)
- **Microrregiões** (`ExIbge.Locality.Microregion`)
- **Regiões Imediatas** (`ExIbge.Locality.ImmediateRegion`)
- **Regiões Intermediárias** (`ExIbge.Locality.IntermediateRegion`)
- **Distritos** (`ExIbge.Locality.District`)
- **Subdistritos** (`ExIbge.Locality.Subdistrict`)
- **Países** (`ExIbge.Locality.Country`)
- **Aglomeração Urbana** (`ExIbge.Locality.UrbanAgglomeration`)
- **Regiões Metropolitanas** (`ExIbge.Locality.MetropolitanRegion`)
- **Regiões Integradas de Desenvolvimento** (`ExIbge.Locality.IntegratedDevelopmentRegion`)

### Outras APIs
- **Agregados** (`ExIbge.Aggregate`) - Séries históricas e pesquisas (SIDRA)
- **Nomes** (`ExIbge.Name`) - Frequência de nomes no Censo

---

## Próximos Passos

### Criar novas funcionalidades
- [ ] Banco de Dados Geodésicos
- [ ] BNGB (Banco de Nomes Geográficos do Brasil)
- [ ] Calendário (Cronograma de ações e publicações)
- [ ] CNAE (Classificação Nacional de Atividades Econômicas)
- [ ] hgeoHNOR (Conversão de altitudes)
- [ ] Malhas Geográficas
- [ ] Metadados (Metadados de pesquisas)
- [ ] Notícias (Agência IBGE Notícias)
- [ ] Países (Indicadores socioeconômicos globais)
- [ ] Pesquisas (Censo, Brasil Cidades, etc.)
- [ ] PPP (Posicionamento por Ponto Preciso)
- [ ] Produtos (Estatística e geociências)
- [ ] ProGriD (Transformação de coordenadas)
- [ ] Publicações (Biblioteca do IBGE)
- [ ] RBMC (Rede Brasileira de Monitoramento Contínuo)
- [ ] RMPG (Rede Maregráfica Permanente para Geodésia)

### Melhorias
- [ ] **Consistência de idiomas**: A API do IBGE utiliza parâmetros em português (ex: `order_by: "nome"`), mas as structs retornadas usam campos em inglês (ex: `name`). Avaliar se devemos aceitar ambos os formatos ou padronizar.
- [ ] **Exemplos práticos com Elixir & Gleam**: Criar exemplos de uso real da biblioteca demonstrando análise de dados geográficos e estatísticos do IBGE.

## Contribuindo

Contribuições são muito bem-vindas! Seja corrigindo bugs, adicionando novas funcionalidades ou melhorando a documentação.

Para detalhes sobre como colaborar, por favor leia nosso [Guia de Contribuição](CONTRIBUTING.md).

Sinta-se livre para abrir PRs implementando qualquer um dos itens acima!
