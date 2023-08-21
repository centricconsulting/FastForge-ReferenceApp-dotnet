import { TodoType } from "../../types";
import { TODO_TYPES } from "../types";

interface TodoListAction {
  type: TODO_TYPES.TODO_LIST;
  payload: { list: TodoType[]; pages: number };
}
interface TodoAction {
  type: TODO_TYPES.TODO_ITEM;
  payload: TodoType;
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

interface TodoDeleteAction {
  type: TODO_TYPES.TODO_DELETE;
  payload: { todoId: string };
}

export type TodoActionTypes =
  | TodoListAction
  | TodoItemAction
  | TodoLoadingAction
  | TodoDisableLoading
  | TodoAction
  | TodoDeleteAction;
