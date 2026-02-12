# Guia do Calendário de Divulgações

O módulo `ExIbge.Calendar` permite consultar o calendário de divulgações do IBGE — publicações de pesquisas, índices e censos programados ou já realizados.

## Conceitos

### Release (Divulgação)
Cada entrada no calendário representa uma divulgação de resultado de pesquisa, com título, data, tipo e pesquisa associada.

---

## Uso

### Listar todas as divulgações

```elixir
ExIbge.Calendar.all!()
# %{
#   count: 2384,
#   page: 1,
#   total_pages: 2384,
#   items: [
#     %ExIbge.Calendar.Release{
#       id: 4365,
#       title: "Pesquisas Trimestrais do Abate de Animais...",
#       release_date: "23/03/2027 12:00:00",
#       ...
#     },
#     ...
#   ]
# }
```

### Com filtros

```elixir
# Limitar quantidade por página
ExIbge.Calendar.all!(quantity: 5)

# Filtrar por período (formato ddMMyyyy)
ExIbge.Calendar.all!(from: "01012024", to: "31122024")

# Combinar filtros
ExIbge.Calendar.all!(quantity: 10, from: "01012024", to: "31122024")
```

### Divulgações por pesquisa

```elixir
ExIbge.Calendar.by_research!(9173)
ExIbge.Calendar.by_research!(9173, quantity: 5)
```

---

## Parâmetros disponíveis

| Parâmetro Elixir | Parâmetro API | Descrição |
|---|---|---|
| `quantity` | `qtd` | Quantidade de itens por página |
| `from` | `de` | Data inicial (formato `ddMMyyyy`) |
| `to` | `ate` | Data final (formato `ddMMyyyy`) |

---

## Paginação

A resposta é automaticamente parseada para um mapa com:
- `count` — total de registros
- `page` — página atual
- `total_pages` — total de páginas
- `items` — lista de `%ExIbge.Calendar.Release{}`
