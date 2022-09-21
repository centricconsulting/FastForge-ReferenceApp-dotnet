import React, { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { defaultTodosCount } from "../../../../core/constants";
import { useActions, useTypedSelector } from "../../../../core/hooks";
import { useTable } from "react-table";
import Table from "../../../../core/components/table";

const ListTodos = () => {
  const { fetchTodos } = useActions();
  const { loading, list } = useTypedSelector((state) => state.todo);

  const [currentPage, setCurrentPage] = useState<number>(0);
  const navigator = useNavigate();

  useEffect(() => {
    fetchTodos({ limit: defaultTodosCount, page: currentPage + 1 });
  }, [defaultTodosCount, currentPage]);

  const COLUMNS = [
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
  ];

  return (
    <>
      <Table columns={COLUMNS as any} data={list} />
    </>
  );
};

export default ListTodos;
