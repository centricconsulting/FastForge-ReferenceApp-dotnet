import React, { ButtonHTMLAttributes, memo } from "react";
import Loading from "./loading";

interface InputProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  loading?: boolean;
  classNames?: string;
}

const _DeleteButton: React.FC<InputProps> = ({
  loading, 
  title,
  classNames,
  ...rest
}) => { 
  return ( 
    <>
      <div className="delete-button">
        <button
          disabled={loading ? true : false}
          className={`delete-button__button ${classNames ? classNames : ""}`}
          {...rest}
        >
          {loading ? <Loading loading={loading} size={14} /> : title}
        </button>
      </div>
    </>
  );
};

const DeleteButton = memo(_DeleteButton);

export { DeleteButton };
