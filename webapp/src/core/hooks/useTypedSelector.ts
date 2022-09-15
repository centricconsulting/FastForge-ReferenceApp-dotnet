import { TypedUseSelectorHook, useSelector } from "react-redux";
import { RootReducer } from "../redux";

export const useTypedSelector: TypedUseSelectorHook<RootReducer> = useSelector;
