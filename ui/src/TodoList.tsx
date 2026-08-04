import { useState } from "react";
import { useMutation, useQuery } from "@apollo/client/react";
import {
  CREATE_TODO,
  DELETE_TODO,
  TODOS_QUERY,
  UPDATE_TODO,
  type Todo,
} from "./graphql/todos";

interface TodosData {
  todos: Todo[];
}

export function TodoList() {
  const [title, setTitle] = useState("");
  const { data, loading, error } = useQuery<TodosData>(TODOS_QUERY);

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

  if (loading) return <p>Loading…</p>;
  if (error) return <p className="error">Could not reach the API: {error.message}</p>;

  const todos = data?.todos ?? [];

  return (
    <section>
      <form onSubmit={handleSubmit} className="new-todo">
        <input
          value={title}
          onChange={(event) => setTitle(event.target.value)}
          placeholder="What needs doing?"
          aria-label="Todo title"
        />
        <button type="submit">Add</button>
      </form>

      {createError && <p className="error">{createError.message}</p>}

      <ul className="todos">
        {todos.map((todo) => (
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
