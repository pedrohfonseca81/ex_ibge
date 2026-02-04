# Guia de Localidades

Este guia fornece exemplos detalhados e explicações sobre como usar os módulos de **Localidades** do ExIbge para navegar pela hierarquia geográfica do Brasil.

## Hierarquia Geográfica

O IBGE organiza o território brasileiro em diversas divisões. O `ExIbge` fornece módulos para acessar cada nível dessa hierarquia.

Abaixo, apresentamos os principais módulos e como utilizá-los.

---

## Regiões (`Region`)

O Brasil é dividido em 5 grandes regiões: Norte, Nordeste, Sudeste, Sul e Centro-Oeste.

```elixir
alias ExIbge.Locality.Region

# Listar todas as regiões
Region.all()
# -> {:ok, [%ExIbge.Geography.Region{id: 3, name: "Sudeste", ...}, ...]}

# Buscar uma região específica pelo ID
Region.find(3)
# -> {:ok, [%ExIbge.Geography.Region{id: 3, name: "Sudeste", ...}]}
```

---

## Estados (`State`)

As Unidades da Federação (UFs). Você pode buscar por ID numérico ou sigla (atom).

```elixir
alias ExIbge.Locality.State

# Listar todos os estados
State.all()

# Buscar Rio de Janeiro pelo ID
State.find(33)

# Buscar São Paulo pela sigla (atom)
State.find(:sp)
# -> {:ok, [%ExIbge.Geography.State{id: 35, sigla: "SP", name: "São Paulo", ...}]}
```

---

## Municípios (`Municipality`)

A menor unidade administrativa autônoma.

```elixir
alias ExIbge.Locality.Municipality

# Buscar município por ID (São Paulo - 3550308)
Municipality.find(3550308)

# Buscar todos os municípios de um estado (usando atom)
Municipality.get_by_state(:sc)

# Buscar todos os municípios de uma região (Sul)
Municipality.get_by_region(4)
```

---

## Distritos e Subdistritos (`District`, `Subdistrict`)

*   **Distritos**: Subdivisões administrativas dos municípios.
*   **Subdistritos**: Subdivisões de distritos (comuns em grandes cidades).

```elixir
alias ExIbge.Locality.District
alias ExIbge.Locality.Subdistrict

# Distritos de um município (ex: Ouro Preto/MG)
District.get_by_municipality(3146107)

# Subdistritos de um distrito
Subdistrict.get_by_district(314610705)
```

---

## Regiões Metropolitanas e RIDE

*   **Regiões Metropolitanas (`MetropolitanRegion`)**: Agrupamentos de municípios limítrofes.
*   **RIDE (`IntegratedDevelopmentRegion`)**: Regiões Integradas de Desenvolvimento (ex: DF e Entorno).
*   **Aglomerações Urbanas (`UrbanAgglomeration`)**: Áreas urbanas contínuas que não formam necessariamente uma RM.

```elixir
alias ExIbge.Locality.MetropolitanRegion
alias ExIbge.Locality.IntegratedDevelopmentRegion

# Todas as RMs de um estado
MetropolitanRegion.get_by_state(:rj)

# Todas as RIDEs
IntegratedDevelopmentRegion.all()
```

---

## Diferença entre Mesorregiões e Microrregiões

Estas são divisões regionais extintas em 2017, substituídas por Regiões Geográficas Intermediárias e Imediatas, mas a API ainda as suporta para fins históricos.

*   **Mesorregião (`Mesoregion`)**: Subdivisão dos estados que agrupa diversos municípios com características sociais e econômicas comuns.
*   **Microrregião (`Microregion`)**: Subdivisão das mesorregiões.

```elixir
alias ExIbge.Locality.Mesoregion
alias ExIbge.Locality.Microregion

Mesoregion.get_by_state(:ba)
Microregion.get_by_mesoregion(2905)
```

## Regiões Intermediárias e Imediatas (Novo Padrão)

Vigentes desde 2017.

*   **Região Geográfica Intermediária (`IntermediateRegion`)**: Articula regiões imediatas.
*   **Região Geográfica Imediata (`ImmediateRegion`)**: Estruturada a partir de centros urbanos próximos.

```elixir
alias ExIbge.Locality.IntermediateRegion
alias ExIbge.Locality.ImmediateRegion

IntermediateRegion.get_by_state(:mg)
ImmediateRegion.get_by_intermediate_region(3101)
```
