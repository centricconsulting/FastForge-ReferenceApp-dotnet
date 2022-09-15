import React from "react";
import { Provider } from "react-redux";
import { PersistGate } from "redux-persist/integration/react";
import { persistor, store } from "./core/redux";
import { MainRoutes } from "./views/routes/index.routes";

const App = () => {
  return (
    <Provider store={store}>
      <PersistGate persistor={persistor}>
        <MainRoutes />
      </PersistGate>
    </Provider>
  );
};

export default App;
