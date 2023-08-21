import React from "react";
import { Provider } from "react-redux";
import { useNavigate } from "react-router-dom";
import { PersistGate } from "redux-persist/integration/react";
import { persistor, store } from "./core/redux";
import { MainRoutes } from "./views/routes/index.routes";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const App = () => {
  const navigate = useNavigate();

  window.openToastSuccess = toast.success;
  window.openToastError = toast.error;
  window.navigate = navigate;

  return (
    <Provider store={store}>
      <PersistGate persistor={persistor}>
        <MainRoutes />
      </PersistGate>
    </Provider>
  );
};

export default App;
