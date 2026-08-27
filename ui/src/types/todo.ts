// Shared filter types. Anything filter-shaped should end up in here.

export type TodoStatus = string;

export interface TodoFilterState {
  status: TodoStatus;
  search: string | null;
}

export type FilterCounts = {
  all: number | null;
  active: number | null;
  completed: number | null;
};

export const DEFAULT_FILTERS: TodoFilterState = {
  status: "all",
  search: null,
};

// NOTE: next sprint we're adding due-date ranges and an assignee filter, and
// product want people to be able to bookmark a filter combination and share it
// with a teammate. Adding each new filter here the same way should be
// straightforward.
