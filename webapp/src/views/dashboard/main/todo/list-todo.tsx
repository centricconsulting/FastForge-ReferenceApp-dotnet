import { faPlus } from "@fortawesome/free-solid-svg-icons";
import React, { useEffect, useMemo, useState } from "react";
import ReactPaginate from "react-paginate";
import { Link, useNavigate } from "react-router-dom";
import { PrimaryButton } from "../../../../core/components";
import Table from "../../../../core/components/table";
import { defaultTodosCount, TODO_COLUMNS } from "../../../../core/constants";
import { useActions, useTypedSelector } from "../../../../core/hooks";

const ListTodos = () => { 
  const { fetchTodos } = useActions();
  const { loading, list,pages } = useTypedSelector((state) => state.todo);

  const [currentPage, setCurrentPage] = useState<number>(0);
  const navigator = useNavigate();

  const queryParams = useMemo(() => {
    return {
      _limit: defaultTodosCount,
      _page: currentPage + 1,
    };
  }, [currentPage]);
 
  useEffect(() => {
    fetchTodos(queryParams);
  }, [defaultTodosCount, currentPage, ]);

  return (
    <>
      <Link to="add-todo"> 
        <PrimaryButton icon={faPlus} title="Add Todo" />
      </Link> 
      <Table columns={TODO_COLUMNS as any} data={list} />
       <ReactPaginate
                forcePage={currentPage}  
                breakLabel="..."
                nextLabel="Next"
                onPageChange={(e) => {
                  setCurrentPage(e.selected);
                }}
                pageRangeDisplayed={5}
                pageCount={pages ?? 1} 
                previousLabel="Prev"
                containerClassName="pagination-container"
                // renderOnZeroPageCount={null}
              />
    </>
  );
};

export default ListTodos;
