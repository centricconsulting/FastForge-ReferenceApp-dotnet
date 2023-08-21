import React, { useMemo, FC } from "react";
import { Column, useTable } from "react-table";
import { classNames } from "../utility";
interface TableTypes {
  columns: Column;
  data: any;
   wrapperClass?: string;
  wrapperClassTHead?: string;
  wrapperClassTBody?: string;
}

const Table: FC<TableTypes> = ({ columns, 
  data,
  wrapperClass,
  wrapperClassTHead,
  wrapperClassTBody, }) => {
  const { getTableProps, getTableBodyProps, headerGroups, rows, prepareRow } =
    useTable({
      columns: useMemo(() => columns as any, [columns]),
      data: useMemo(() => data ?? [], [data]),
    });
  return (
    <>
      <table className={classNames(wrapperClass, "react-table")} {...getTableProps()}>
        <thead className={classNames(wrapperClassTHead, "react-table-header")}>
          {headerGroups.map((headerGroup) => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map((column) => (
                <th {...column.getHeaderProps()}>
                  {column.render("Header") as any}{" "}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody  className={classNames(wrapperClassTBody, "react-table-body")} {...getTableBodyProps()}>
          {rows.map((row, i) => {
            prepareRow(row);
            return (
              <tr {...row.getRowProps()}>
                {row.cells.map((cell) => {
                  return ( 
                    <td {...cell.getCellProps()}>
                      {cell.render("Cell") as any}
                    </td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </table>
    </>
  );
};

export default Table;
