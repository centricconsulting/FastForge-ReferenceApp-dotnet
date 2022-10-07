import React from "react";
import "./core/styles/index.scss";
import App from "./App";
import { BrowserRouter } from "react-router-dom";
import * as ReactDOMClient from "react-dom/client";
import "bootstrap/dist/css/bootstrap.css";
import { ToastContainer } from "react-toastify"; 
// Put any other imports below so that CSS from your
// components takes precedence over default styles.

const root = ReactDOMClient.createRoot(
  document.getElementById("root") as Element
);
root.render(
  <BrowserRouter>
    <App />
    <ToastContainer theme="colored" />
  </BrowserRouter>
);
