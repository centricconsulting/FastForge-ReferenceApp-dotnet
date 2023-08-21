import React from "react";
import { Navigate, Route, Routes } from "react-router-dom";
import Todos from "./todo";

const Main = () => {
  return (
    <>
      <Routes>
        <Route path="" element={<Navigate to="/todos" />} />
        <Route path="todos/*" element={<Todos />} />
        {/* <Route path="*" element={<Navigate to="profile" />} /> */}
      </Routes>
    </>
  );
};

export default Main;
