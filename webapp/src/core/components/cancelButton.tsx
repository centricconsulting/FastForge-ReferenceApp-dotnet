import React, { ButtonHTMLAttributes, memo } from "react";
import Loading from "./loading";

interface InputProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  loading?: boolean;
  classNames?: string;  
} 

const _CancelButton: React.FC<InputProps> = ({
  loading,
  title,
  classNames, 
  ...rest
}) => {
  return (
    <>
      <div className="cancel-button">
        <button
          className={`cancel-button__button ${classNames ? classNames : ""}`}
          disabled={loading ? true : false}
          {...rest}
        >
          {loading ? <Loading loading={loading} size={14} /> : title}
        </button>
      </div>
    </>
  );
};

const CancelButton = memo(_CancelButton);

export { CancelButton };
