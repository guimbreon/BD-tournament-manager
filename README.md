# Tournament Manager

[Portuguese Version](README-PT.md)

## Description

This project is a tournament management system that allows the administration of editions, phases, matches, players, teams, and tickets. It was developed as part of the **Database Management** course for the academic year 2024/25.

## Features

- Create and manage tournaments and their editions.
- Control phases and matches in virtual arenas.
- Associate players with teams and define roles.
- Manage tickets for in-person and online matches.
- Enable recommendations among spectators.
- Accumulate and track spectator credits.

## Requirements

- **Language**: SQL (for the database)
- **DBMS**: PostgreSQL / MySQL / phpAdmin (as needed)
- **Dependencies**: None at the moment

## Database Structure

The database follows the following integrity rules:

- A tournament must have at least one edition.
- Each edition can contain multiple games and phases.
- Players can be associated with different teams over time.
- Each match takes place in a virtual arena or an online platform.
- Spectators can purchase tickets and recommend other users.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/guimbreon/BD-tournament-manager.git
   ```
2. Import the database schema:
   ```sql
   SOURCE BD-2425-E2_bd013_TP12.sql;
   ```
3. Configure the DBMS according to the project requirements.

## Authors

- **Guilherme Soares** - Database development and modeling.

## License

This project is academic in nature and does not have a specific license. If you wish to use it, please contact the author.
