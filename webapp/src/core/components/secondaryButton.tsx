import React, { ButtonHTMLAttributes, memo } from "react";
import Loading from "./loading";

interface InputProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  loading?: boolean;
  buttonType?: "primary" | "secondary";
  classNames?: string;
}

const _SecondaryButton: React.FC<InputProps> = ({
  buttonType,
  loading,
  title,
  classNames,
  ...rest
}) => {
  return (
    <>
      <div className="secondary-button">
        <button
          disabled={loading ? true : false}
          className={`secondary-button__button ${classNames ? classNames : ""}`}
          {...rest}
        >
          {loading ? <Loading loading={loading} size={14} /> : title}
        </button>
      </div>
    </>
  );
};

const SecondaryButton = memo(_SecondaryButton);

export { SecondaryButton };
