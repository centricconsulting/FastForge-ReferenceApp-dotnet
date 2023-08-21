import React, { ButtonHTMLAttributes, memo } from "react";
import Loading from "./loading";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { IconLookup } from "@fortawesome/fontawesome-svg-core";
interface InputProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  loading?: boolean;
  buttonType?: "primary" | "secondary";
  classNames?: string; 
  icon?: IconLookup; 
} 

const _PrimaryButton: React.FC<InputProps> = ({
  buttonType,
  loading,
  title,
  classNames,
  icon, 
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
          {loading ? <Loading loading={loading} size={14} /> : 
          (icon ? <>{title} <FontAwesomeIcon icon={icon} /> </> : title) 
          }
        </button>
      </div>
    </>
  );
};

const PrimaryButton = memo(_PrimaryButton);

export { PrimaryButton };
