import { combineReducers } from "redux";
import todoReducer from "./todoReducer";

const rootReducer = combineReducers({
  todo: todoReducer,
});

export default rootReducer;

export type RootReducer = ReturnType<typeof rootReducer>;
