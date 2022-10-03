import React from "react";

import { Route, Routes } from "react-router-dom";
import { AddTodo } from "./add-todo";
import {EditTodo} from "./edit-todo"; 
import ListTodos from "./list-todo";

const Todos = () => {
  return (
    <Routes>
      <Route path="" element={<ListTodos />} />
      <Route path="/add-todo" element={<AddTodo />} />
      <Route path="/edit-todo" element={<EditTodo />} />
    </Routes>
  );
};

export default Todos;
