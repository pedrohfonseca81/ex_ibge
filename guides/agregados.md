# Guia de Agregados (Séries Históricas e Pesquisas)

O módulo de **Agregados** (`ExIbge.Aggregate`) permite acessar dados estatísticos do IBGE (SIDRA), como censos, pesquisas de preços (IPCA), produção agrícola, etc.

Esta API é mais complexa que a de Localidades pois envolve conceitos multidimensionais: Agregados, Variáveis, Classificações e Períodos.

---

## Conceitos Básicos

*   **Pesquisa**: Um levantamento amplo (ex: Censo Demográfico).
*   **Agregado**: Uma tabela específica da pesquisa (ex: População residente por sexo).
*   **Variável**: O dado que está sendo medido (ex: População residente).
*   **Classificação**: Categorias para filtrar os dados (ex: Situação do domicílio, Sexo).
*   **Período**: A data de referência do dado (ex: 2010, 202401).

---

## Descobrindo Dados

Para encontrar dados, você geralmente começa listando os agregados de uma pesquisa ou buscando por assunto.

```elixir
alias ExIbge.Aggregate

# Listar pesquisas sobre "Abate de animais" (assunto 70)
Aggregate.all(subject: 70)

# Ver metadados de um agregado específico (ex: 1705)
# Isso mostra quais variáveis e classificações estão disponíveis
Aggregate.get_metadata(1705)
```

---

## Consultando Dados

A função principal é `get_variables/4`. Ela é poderosa e permite diversos filtros.

### Exemplo: Produção Agrícola (PAM)

Vamos consultar a produção de **Abacaxi** (Produto) no **Brasil** nos últimos anos.

1.  **Agregado**: 1612 (Área plantada, colhida, etc.)
2.  **Variáveis**: 214 (Quantidade produzida)
3.  **Períodos**: -3 (Últimos 3 anos)
4.  **Localidade**: BR (Brasil)
5.  **Classificação**: 81 (Produto das lavouras) -> Categoria 2688 (Abacaxi)

```elixir
Aggregate.get_variables(
  1612,               # ID do Agregado
  "-3",               # Períodos (últimos 3)
  "214",              # ID da Variável
  locations: "BR",  # Filtro de localidade
  classifications: "81[2688]" # Classificação
)
```

### Exemplo: IPCA (Inflação)

Consultar o IPCA acumulado em 12 meses para a região metropolitana do Rio de Janeiro.

```elixir
Aggregate.get_variables(
  1737,               # Agregado do IPCA
  "202312",           # Período (Dez/2023)
  "2265",             # Variável (IPCA acumulado 12 meses)
  locations: "N7[3301]" # Região Metropolitana do RJ
)
```

---

## Dicas

*   Use `get_metadata(id)` para entender os códigos (Ids) de variáveis e classificações. A API do SIDRA usa muitos códigos numéricos.
*   Você pode usar "pipes" (`|`) para pedir múltiplos valores. Ex: `periodos: "2020|2021"`.
*   Para localidades, use os níveis geográficos adequados (N1=Brasil, N6=Município, etc.).
