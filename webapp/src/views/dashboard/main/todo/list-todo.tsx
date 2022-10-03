import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useNavigate } from "react-router-dom";
import { PrimaryButton } from "../../../../core/components";
import Table from "../../../../core/components/table";
import { defaultTodosCount, TODO_COLUMNS } from "../../../../core/constants";
import { useActions, useTypedSelector } from "../../../../core/hooks";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus } from "@fortawesome/free-solid-svg-icons";

const ListTodos = () => {
  const { fetchTodos } = useActions();
  const { loading, list } = useTypedSelector((state) => state.todo);

  const [currentPage, setCurrentPage] = useState<number>(0);
  const navigator = useNavigate();
 
  useEffect(() => {
    fetchTodos({ limit: defaultTodosCount, page: currentPage + 1 });
  }, [defaultTodosCount, currentPage]);

  return (
    <>
      <Link to="add-todo"> 
        <PrimaryButton icon={faPlus} title="Add Todo" />
      </Link> 
      <Table columns={TODO_COLUMNS as any} data={list} />
    </>
  );
};

export default ListTodos;
