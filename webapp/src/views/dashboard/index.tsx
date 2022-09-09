import React from "react";
import Main from "./main";

const Dashboard = () => {
  return (
    <>
      {/* <HeaderDashboard openDrawer={setOpen} /> */}
      <div className="dashboard-wrapper">
        {/* <Drawer open={open} openDrawer={setOpen} /> */}
        <main className="main-dashboard">
          <Main />
        </main>
      </div>
    </>
  );
};

export default Dashboard;
