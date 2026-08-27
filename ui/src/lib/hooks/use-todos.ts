import { useQuery } from "@apollo/client/react";
import { TODOS_QUERY, TODO_COUNTS_QUERY, type Todo } from "../../todos/queries";
import type { FilterCounts, TodoFilterState } from "../../types/todo";

interface TodosData {
  todos: Todo[];
}

interface CountsData {
  todoCounts: FilterCounts;
}

// Everything the todo page needs, in one call.
export function useTodos(filters: TodoFilterState) {
  const { data, loading, error } = useQuery<TodosData>(TODOS_QUERY, {
    variables: {
      status: filters.status,
      search: filters.search,
    },
    fetchPolicy: "no-cache",
  });

  const counts = useQuery<CountsData>(TODO_COUNTS_QUERY);

  // Keep the current filters in the URL so they survive a refresh.
  const params = new URLSearchParams(window.location.search);
  params.set("status", filters.status);
  params.set("q", filters.search ?? "");
  window.history.replaceState(null, "", `?${params}`);

  return {
    todos: data?.todos ?? [],
    counts: counts.data?.todoCounts ?? { all: 0, active: 0, completed: 0 },
    loading,
    error,
  };
}
