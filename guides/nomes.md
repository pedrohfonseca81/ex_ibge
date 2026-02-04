# Guia de nomes

O módulo `ExIbge.Name` permite consultar a frequência de nomes no Brasil, baseado nos dados do Censo 2010.

## Conceitos

### Frequência por década
A API retorna quantas pessoas nasceram com determinado nome em cada década, desde 1930 até 2010.

### Ranking
Lista os nomes mais populares, podendo filtrar por década, localidade ou sexo.

## Uso

### Consultar frequência de um nome

```elixir
ExIbge.Name.frequency!("joao")
# [%ExIbge.Name.Frequency{
#   name: "JOAO",
#   locality: "BR",
#   sex: nil,
#   results: [
#     %{period: "1930[", frequency: 60155},
#     %{period: "[1950,1960[", frequency: 396438},
#     ...
#   ]
# }]
```

### Consultar múltiplos nomes

```elixir
ExIbge.Name.frequency!(["joao", "maria"])
```

### Filtrar por sexo

```elixir
ExIbge.Name.frequency!("ariel", sexo: "F")
ExIbge.Name.frequency!("ariel", sexo: "M")
```

### Agrupar por UF

```elixir
ExIbge.Name.frequency!("joao", group_by: "UF")
```

### Filtrar por localidade

```elixir
# Por estado usando atom
ExIbge.Name.frequency!("joao", localidade: :rj)

# Por estado usando ID
ExIbge.Name.frequency!("joao", localidade: "33")

# Por município (Angra dos Reis = 3300100)
ExIbge.Name.frequency!("joao", localidade: "3300100")
```

## Ranking

### Top nomes do Brasil

```elixir
ExIbge.Name.ranking!()
# [%ExIbge.Name.Ranking{
#   locality: "BR",
#   sex: nil,
#   results: [
#     %{name: "MARIA", frequency: 11734129, ranking: 1},
#     %{name: "JOSE", frequency: 5754529, ranking: 2},
#     ...
#   ]
# }]
```

### Ranking por década

```elixir
ExIbge.Name.ranking!(decada: "1980")
```

### Ranking por sexo

```elixir
ExIbge.Name.ranking!(sexo: "F")
ExIbge.Name.ranking!(sexo: "M")
```

### Ranking por localidade

```elixir
ExIbge.Name.ranking!(localidade: "33")
```

## Limitações

- Nomes compostos não são suportados (ex: "Maria Luiza")
- Mínimo de ocorrências: 10 por município, 15 por UF, 20 no Brasil
- Sinais diacríticos são ignorados (Antônio = Antonio)
