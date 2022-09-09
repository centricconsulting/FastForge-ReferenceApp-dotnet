import { TodoType } from "../../types";
import { TodoItemActionTypes } from "../actionTypes";
import { TODO_TYPES } from "../types";

interface StateType {
  list: TodoType[] | null;
  item: TodoType | null;
  loading: boolean;
}

const initialState: StateType = {
  list: null,
  item: null,
  loading: false,
};

const reducer = (
  state: StateType = initialState,
  action: TodoItemActionTypes
): StateType => {
  switch (action.type) {
    case TODO_TYPES.TODO_LIST:
      return {
        ...state,
        list: action.payload,
        loading: false,
        item: null,
      };

    case TODO_TYPES.TODO_ITEM:
      return {
        ...state,
        item: action.payload,
        loading: false,
      };

    case TODO_TYPES.TODO_LOADING:
      return {
        ...state,
        loading: true,
      };

    case TODO_TYPES.DISABLE_LOADING:
      return {
        ...state,
        loading: false,
      };

    default:
      return state;
  }
};

export default reducer;
