import React from "react";
import "./core/styles/index.scss";
import App from "./App";
import { BrowserRouter } from "react-router-dom";
import * as ReactDOMClient from "react-dom/client";

const root = ReactDOMClient.createRoot(
  document.getElementById("root") as Element
);
root.render(
  <BrowserRouter>
    <App />
  </BrowserRouter>
);
