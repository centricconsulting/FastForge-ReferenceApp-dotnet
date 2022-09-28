import { Column } from "react-table";

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
    Cell: ({ value }) => {
      return value ? "Yes" : "No";
    },
  },
];
