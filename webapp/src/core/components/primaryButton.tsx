import React, { ButtonHTMLAttributes, memo } from "react";
import Loading from "./loading";

interface InputProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  loading?: boolean;
  buttonType?: "primary" | "secondary";
  classNames?: string;
}

const _PrimaryButton: React.FC<InputProps> = ({
  buttonType,
  loading,
  title,
  classNames,
  ...rest
}) => {
  return (
    <>
      <div className="primary-button">
        <button
          disabled={loading ? true : false}
          className={`primary-button__button ${classNames ? classNames : ""}`}
          {...rest}
        >
          {loading ? <Loading loading={loading} size={14} /> : title}
        </button>
      </div>
    </>
  );
};

const PrimaryButton = memo(_PrimaryButton);

export { PrimaryButton };
