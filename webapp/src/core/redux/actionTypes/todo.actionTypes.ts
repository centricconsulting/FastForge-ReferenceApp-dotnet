import { TodoType } from "../../types";
import { TODO_TYPES } from "../types";

interface TodoListAction {
  type: TODO_TYPES.TODO_LIST;
  payload: TodoType[];
}

interface TodoItemAction {
  type: TODO_TYPES.TODO_ITEM;
  payload: TodoType;
}

interface TodoLoadingAction {
  type: TODO_TYPES.TODO_LOADING;
}

interface TodoDisableLoading {
  type: TODO_TYPES.DISABLE_LOADING;
}

export type TodoItemActionTypes =
  | TodoListAction
  | TodoItemAction
  | TodoLoadingAction
  | TodoDisableLoading;
