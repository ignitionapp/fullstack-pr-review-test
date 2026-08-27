import { gql } from "@apollo/client";

export interface Todo {
  id: string;
  title: string;
  completed: boolean;
}

export const TODOS_QUERY = gql`
  query Todos($status: String, $search: String) {
    todos(status: $status, search: $search) {
      id
      title
      completed
    }
  }
`;

export const TODO_COUNTS_QUERY = gql`
  query TodoCounts {
    todoCounts {
      all
      active
      completed
    }
  }
`;

export const CREATE_TODO = gql`
  mutation CreateTodo($title: String!) {
    createTodo(input: { title: $title }) {
      todo {
        id
        title
        completed
      }
      errors
    }
  }
`;

export const UPDATE_TODO = gql`
  mutation UpdateTodo($id: ID!, $completed: Boolean) {
    updateTodo(input: { id: $id, completed: $completed }) {
      todo {
        id
        title
        completed
      }
      errors
    }
  }
`;

export const DELETE_TODO = gql`
  mutation DeleteTodo($id: ID!) {
    deleteTodo(input: { id: $id }) {
      id
      errors
    }
  }
`;
