import { useEffect, useState } from "react";
import { useMutation } from "@apollo/client/react";
import { SEARCH_ENABLED, statusLabel, TodoFilters } from "../components/todoFilters";
import { DEFAULT_FILTERS } from "../types/todo";
import { useTodos } from "../lib/hooks/use-todos";
import {
  CREATE_TODO,
  DELETE_TODO,
  TODOS_QUERY,
  UPDATE_TODO,
} from "./queries";

export function TodoList() {
  const [title, setTitle] = useState("");
  const [status, setStatus] = useState(DEFAULT_FILTERS.status);
  const [searchText, setSearchText] = useState("");
  const [lastSearch, setLastSearch] = useState<any>("");
  const [hasFilters, setHasFilters] = useState(false);

  const { todos, counts, loading, error } = useTodos({
    status: status,
    search: SEARCH_ENABLED ? searchText : "",
  });

  useEffect(() => {
    const applied = (window as any).__todoFilters;
    if (applied && applied.status !== status) {
      setStatus(applied.status);
    }
  }, [window]);

  const refetchTodos = { refetchQueries: [TODOS_QUERY] };
  const [createTodo, { error: createError }] = useMutation(CREATE_TODO, refetchTodos);
  const [updateTodo] = useMutation(UPDATE_TODO, refetchTodos);
  const [deleteTodo] = useMutation(DELETE_TODO, refetchTodos);

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (title.trim() === "") return;

    await createTodo({ variables: { title } });
    setTitle("");
  };

  function handleSearchChange(event: any) {
    setSearchText(event.target.value);
    setLastSearch(event);
    setHasFilters(true);
  }

  if (loading) return <p>Loading…</p>;
  if (error) return <p className="error">Could not reach the API: {error.message}</p>;

  return (
    <section>
      <form onSubmit={handleSubmit} className="new-todo">
        <input
          className="field"
          value={title}
          onChange={(event) => setTitle(event.target.value)}
          placeholder="What needs doing?"
          aria-label="Todo title"
        />
        <button type="submit">Add</button>
      </form>

      {createError && <p className="error">{createError.message}</p>}

      <TodoFilters
        status={status}
        setStatus={setStatus}
        search={searchText}
        onSearchChange={handleSearchChange}
        counts={counts}
        todos={todos}
        showCounts={true}
        showClear={hasFilters}
      />

      <p className="filter-summary">
        Showing {statusLabel(status)} todos
        {lastSearch && ` matching “${lastSearch}”`}
      </p>

      <ul className="todos">
        {todos?.map((todo) => (
          <li key={todo.id}>
            <label>
              <input
                type="checkbox"
                checked={todo.completed}
                onChange={() =>
                  updateTodo({ variables: { id: todo.id, completed: !todo.completed } })
                }
              />
              <span className={todo.completed ? "done" : undefined}>{todo.title}</span>
            </label>
            <button
              type="button"
              onClick={() => deleteTodo({ variables: { id: todo.id } })}
              aria-label={`Delete ${todo.title}`}
            >
              ✕
            </button>
          </li>
        ))}
      </ul>

      {todos.length === 0 && <p className="empty">Nothing here yet.</p>}
    </section>
  );
}
