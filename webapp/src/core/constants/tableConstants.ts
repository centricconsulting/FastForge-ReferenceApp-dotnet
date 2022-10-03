import { FC } from "react";
import { Column } from "react-table";
import {TableActionIcons} from "../components"



export const TODO_COLUMNS: Column[] = [
  {
    Header: "ID",
    accessor: "id",
  },
  {
    Header: "Title",
    accessor: "title",
  },
  {
    Header: "Description",
    accessor: "description",
  },
  {
    Header: "Urgency",
    accessor: "urgent",
    
  }, 
   {
    Header: "Actions", 
     Cell: TableActionIcons,   
  },
]; 
