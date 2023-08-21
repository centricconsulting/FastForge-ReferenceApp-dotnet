import { applyMiddleware, createStore } from "redux";
import thunk from "redux-thunk";

import { persistReducer, persistStore } from "redux-persist";
import storage from "redux-persist/lib/storage";
import rootReducer from "./reducers";
const persistConfig = {
  key: "root",
  storage: storage,
  whitelist: ["auth"],
};
const pReducer = persistReducer(persistConfig, rootReducer);
const middleware = applyMiddleware(thunk);
const store = createStore(pReducer, middleware);
const persistor = persistStore(store);

export { persistor, store };
