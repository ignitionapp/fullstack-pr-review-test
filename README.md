# todo-app

A minimal to-do list app: Rails GraphQL API + React frontend. Split into `api/` and `ui/`,
mirroring the `ignitionapp` layout at a much smaller scale.

## Stack

| Part | Tech |
| --- | --- |
| `api/` | Rails 8.1 (API-only), PostgreSQL, `graphql-ruby` 2.6, `rack-cors` |
| `ui/` | React 19, TypeScript, Vite 8, Apollo Client 4 |

Ports: API on **3010**, UI on **5173**.

## Prerequisites

- Ruby 3.4.x
- Node 22+
- PostgreSQL running locally

## Setup

```bash
cd api && bundle install && bin/rails db:setup
```

```bash
cd ui && npm install
```

## Running

Two terminals:

```bash
cd api && bin/rails server
```

```bash
cd ui && npm run dev
```

Then open http://localhost:5173.

## GraphQL API

Single endpoint: `POST http://localhost:3010/graphql`.

```
query   todos: [Todo!]!
query   todo(id: ID!): Todo
mutation createTodo(input: { title: String! })
mutation updateTodo(input: { id: ID!, title: String, completed: Boolean })
mutation deleteTodo(input: { id: ID! })
```

Mutations return an `errors: [String!]!` field carrying validation messages, rather than
raising top-level GraphQL errors.

Example:

```bash
curl -s -X POST http://localhost:3010/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ todos { id title completed } }"}'
```

There is no GraphiQL UI (the Rails app is API-only). Use curl, or point a GraphQL client
such as Altair or Apollo Sandbox at the endpoint.

## Layout

```
api/
  app/graphql/
    api_schema.rb          # schema root
    types/query_type.rb     # todos, todo
    types/mutation_type.rb  # createTodo, updateTodo, deleteTodo
    types/todo_type.rb
    mutations/              # one file per mutation
  app/models/todo.rb
  config/initializers/cors.rb
ui/
  src/apolloClient.ts       # Apollo client, reads VITE_GRAPHQL_URL
  src/graphql/todos.ts      # queries, mutations, Todo type
  src/TodoList.tsx          # the list + form
  src/App.tsx
```

## Configuration

- `api`: `CORS_ORIGINS` (default `http://localhost:5173`), `PORT` (default `3010`)
- `ui`: `VITE_GRAPHQL_URL` in `ui/.env` (default `http://localhost:3010/graphql`)

## Intentionally left out

No tests, no auth, no GraphQL codegen, no Docker, no CI. TypeScript types for GraphQL
operations are hand-written in `ui/src/graphql/todos.ts`; swap in `graphql-codegen` when the
schema grows.
