import React, { ButtonHTMLAttributes, memo, useState, useCallback } from "react";
import Loading from "./loading";
import { Link, useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { IconProp } from "@fortawesome/fontawesome-svg-core";
import { faPen, faTrash } from "@fortawesome/free-solid-svg-icons";
import { CellPropGetter, CellProps } from "react-table";
import {DeleteModalContent} from ".";
import {TodoType} from "../types";
import { useActions } from "../../core/hooks";

const _TableActionIcons: React.FC<CellProps<{}>> = (props) => {
  const navigator = useNavigate();
   const {deleteTodo } = useActions();
  const [isOpen, setIsOpen] = useState<boolean>(false);
 const onSuccesDeleteModal = useCallback(() => {
    deleteTodo(props.row.values.id);
    setIsOpen(false); 
  }, [deleteTodo]); 
 
  return (
    <> 
      <DeleteModalContent
        isOpen={isOpen}
        title={
        ""  + (props.row.values.title)
        }
        message="Are you Sure You want to Delete this Todo?"
        onCancel={() => {
          setIsOpen(false);
        }}
        onSuccess={onSuccesDeleteModal}
      />
    <div className="icon-wrapper">  
      <span 
        onClick={(e) => {
          e.stopPropagation();  
          navigator(`edit-todo?_id=${props.row.values.id}`);
        }}
      >
        <FontAwesomeIcon className="edit-icon" icon={faPen} /> 
      </span>
      <span 
      onClick={(e) => {
        e.stopPropagation();
        setIsOpen(true) 
      }}
      >
        <FontAwesomeIcon className="delete-icon" icon={faTrash} />
      </span>
    </div>
    </>
  );
};

const TableActionIcons = memo(_TableActionIcons);

export { TableActionIcons };
