import React from "react";

import { Route, Routes } from "react-router-dom";
import { AddTodo } from "./add-todo";
import ListTodos from "./list-todo";

const Todos = () => {
  return (
    <Routes>
      <Route path="" element={<ListTodos />} />
      <Route path="/add-todo" element={<AddTodo />} />
    </Routes>
  );
};

export default Todos;
