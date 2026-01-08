# Tournament Manager

This README is also available in English. [Click here](README.md)
Project made by:
[Guilherme Soares](https://github.com/guimbreon) && [Vitória Correia](https://github.com/vitoriateixeiracorreia)
## Descrição

Este projeto é um sistema de gestão de torneios, permitindo administrar edições, fases, encontros, jogadores, equipas e bilhetes. Ele foi desenvolvido como parte da disciplina de **Bases de Dados** no ano letivo 2024/25.

## Funcionalidades

- Criar e gerir torneios e suas edições.
- Controlar fases e encontros em arenas virtuais.
- Associar jogadores a equipas e definir papéis.
- Gerir bilhetes para encontros presenciais e online.
- Permitir recomendações entre espectadores.
- Acumular e controlar créditos de espectadores.

## Requisitos

- **Linguagem**: SQL (para a base de dados)
- **SGDB**: PostgreSQL / MySQL (conforme necessidade)
- **Dependências**: Nenhuma até o momento

## Estrutura da Base de Dados

A base de dados segue as seguintes regras de integridade:

- Um torneio deve possuir pelo menos uma edição.
- Cada edição pode conter vários jogos e fases.
- Jogadores podem estar associados a diferentes equipas ao longo do tempo.
- Cada encontro ocorre numa arena virtual ou plataforma online.
- Os espectadores podem adquirir bilhetes e recomendar outros utilizadores.

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/guimbreon/BD-tournament-manager.git
   ```
2. Importe o esquema da base de dados:
   ```sql
   SOURCE BD-2425-E2_bd013_TP12.sql;
   ```
3. Configure o SGDB conforme os requisitos do projeto.

## Autores

- **Guilherme Soares** - Desenvolvimento e modelagem da base de dados.

## Licença

Este projeto é de caráter acadêmico e não possui uma licença específica. Caso deseje utilizá-lo, entre em contato com o autor.

