import * as React from "react";
import { Route, Routes } from "react-router-dom";
import Dashboard from "../dashboard";

function MainRoutes() {
  // const { token } = useTypedSelector((state) => state.auth);

  return (
    <Routes>
      <Route path="*" element={<Dashboard />} />
      {/* <Route path="login" element={<Login />} /> */}
      {/* <Route path="404" element={<Login />} /> */}
      {/* <Route path="*" element={<Navigate to="/login" />} /> */}
    </Routes>
  );
}

export { MainRoutes };
