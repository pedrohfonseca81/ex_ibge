# Guia de Contribuição

Obrigado pelo interesse em contribuir para o **ExIbge**!
Este documento define as diretrizes para garantir que as contribuições sejam integradas de forma suave e mantenham a qualidade do projeto.

## Como Contribuir

1.  **Faça um Fork e Clone o Repositório**
    *   Faça um fork do projeto no GitHub.
    *   Clone o fork para sua máquina local:
        ```bash
        git clone https://github.com/pedrohfonseca81/ex_ibge.git
        cd ex_ibge
        ```

2.  **Instale as Dependências**
    *   Certifique-se de ter o Elixir instalado.
    *   Instale as dependências do projeto:
        ```bash
        mix deps.get
        ```

3.  **Crie uma Branch de Feature**
    *   Crie uma branch com um nome descritivo para sua alteração:
        ```bash
        git checkout -b feature/minha-nova-funcionalidade
        ```

4.  **Implemente e Teste**
    *   Escreva seu código seguindo o estilo do projeto.
    *   **Adicione testes** para novas funcionalidades.
    *   Garanta que todos os testes existentes passem:
        ```bash
        mix test
        ```
    *   Verifique a formatação do código:
        ```bash
        mix format --check-formatted
        ```

5.  **Documentação**
    *   Se você adicionou ou alterou funcionalidades, atualize a documentação (`@moduledoc`, `@doc`).
    *   Gere a documentação localmente para visualizar:
        ```bash
        mix docs
        ```

6.  **Envie seu Pull Request (PR)**
    *   Faça o push da sua branch:
        ```bash
        git push origin feature/minha-nova-funcionalidade
        ```
    *   Abra um Pull Request no repositório original.
    *   Descreva claramente o que foi feito e o motivo.

## Padrões de Código

*   Seguimos o guia de estilo padrão do Elixir.
*   Use `mix format` antes de comitar.
*   Mantenha nomes de variáveis e funções em inglês para consistência com o ecossistema Elixir, mas a documentação ("@doc") pode ser mantida em português/inglês conforme o padrão existente (atualmente misto/português focado no contexto BR).

## Reportando Bugs

Se encontrar um bug, por favor abra uma **Issue** informando:
*   Versão do Elixir.
*   Passos para reproduzir o erro.
*   Comportamento esperado vs. comportamento atual.

Obrigado por ajudar a construir um ecossistema Elixir mais forte para dados brasileiros! 🚀
