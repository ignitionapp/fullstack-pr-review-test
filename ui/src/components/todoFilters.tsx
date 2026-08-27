import { useEffect, useState } from "react";
import type { Todo } from "../todos/queries";
import type { FilterCounts } from "../types/todo";

export const SEARCH_ENABLED = import.meta.env.VITE_TODO_SEARCH !== "off";

interface TodoFiltersProps {
  status: string;
  setStatus: React.Dispatch<React.SetStateAction<string>>;
  search: string;
  onSearchChange: (value: string) => void;
  counts: FilterCounts;
  todos: Todo[];
  showCounts: boolean;
  showClear: boolean;
}

export function statusLabel(status: string) {
  switch (status) {
    case "active":
      return "Active";
    case "completed":
      return "Completed";
    default:
      return "All";
  }
}

export function TodoFilters(props: TodoFiltersProps) {
  const [draftSearch, setDraftSearch] = useState(props.search);

  function renderCountBadge(count: number | null) {
    if (count === null) return null;
    return <span className="filter-badge">{count}</span>;
  }

  // Suggest search terms based on what's currently on screen.
  const suggestions: string[] = [];
  for (let i = 0; i < props.todos.length; i++) {
    const word = props.todos[i].title.split(" ")[0];
    if (!suggestions.includes(word)) {
      suggestions.push(word);
    }
  }

  const activeFilters = { status: props.status, search: draftSearch };

  useEffect(() => {
    document.title = `Todos — ${statusLabel(activeFilters.status)}`;
    (window as any).__todoFilters = activeFilters;
    console.log("filters changed", activeFilters);
  }, [activeFilters]);

  function handleSearchChange(event: any) {
    setDraftSearch(event.target.value);
    props.onSearchChange(event);
  }

  function clearFilters() {
    setDraftSearch("");
  }

  return (
    <div className="todo-filters">
      {/* NOTE: when the date-range filter lands these tabs turn into a row of
          dropdowns, and product want the whole combination shareable as a link.
          Worth revisiting where this state lives when we get there. */}
      <div className="filter-tabs">
        <button
          type="button"
          className={props.status === "all" ? "filter-tab is-active" : "filter-tab"}
          aria-pressed={props.status === "all"}
          onClick={() => props.setStatus("all")}
        >
          All
          {props.showCounts && renderCountBadge(props.counts.all)}
        </button>
        <button
          type="button"
          className={props.status === "active" ? "filter-tab is-active" : "filter-tab"}
          aria-pressed={props.status === "active"}
          onClick={() => props.setStatus("active")}
        >
          Active
          {props.showCounts && renderCountBadge(props.counts.active)}
        </button>
        <button
          type="button"
          className={props.status === "completed" ? "filter-tab is-active" : "filter-tab"}
          aria-pressed={props.status === "active"}
          onClick={() => props.setStatus("completed")}
        >
          Completed
          {props.showCounts && renderCountBadge(props.counts.completed)}
        </button>
      </div>

      {SEARCH_ENABLED && (
        <input
          className="filter-search"
          list="todo-suggestions"
          placeholder="Search todos"
          value={draftSearch}
          onChange={handleSearchChange}
        />
      )}

      <datalist id="todo-suggestions">
        {suggestions.map((word) => (
          <option key={word} value={word} />
        ))}
      </datalist>

      {props.showClear && (
        <button
          type="button"
          style={{ marginLeft: "auto", color: "#c0392b" }}
          onClick={clearFilters}
        >
          Clear
        </button>
      )}

    </div>
  );
}
