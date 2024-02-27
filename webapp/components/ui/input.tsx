import { useState, InputHTMLAttributes, forwardRef } from "react";
import { EyeIcon, EyeOff } from "lucide-react";

import { cn } from "@/lib/utils";

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  error?: string;
  label?: string;
}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, error, label, id, ...props }, ref) => {
    const [showPassword, setShowPassword] = useState(false);

    const handleShowPassword = () => {
      setShowPassword((pre) => !pre);
    };

    const passwordType = () => {
      if (type === "password") return showPassword ? "text" : "password";
      return type;
    };

    return (
      <div className="flex flex-col items-start relative">
        {!!label && (
          <label
            htmlFor={id}
            className="block mb-2 text-base font-bold text-gray-dark text-start"
          >
            {label}
          </label>
        )}
        <input
          type={passwordType()}
          className={cn(
            `${
              error ? "border-error" : "border-input"
            } flex h-10 w-full rounded-md border  bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-gray-light focus-visible:outline-none focus-visible:border-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-1 disabled:cursor-not-allowed disabled:opacity-50`,
            className
          )}
          ref={ref}
          {...props}
        />
        {type === "password" &&
          (showPassword ? (
            <EyeOff
              className="absolute top-[2.5rem] right-[1rem] cursor-pointer"
              onClick={handleShowPassword}
            />
          ) : (
            <EyeIcon
              className="absolute top-[2.5rem] right-[1rem] cursor-pointer"
              onClick={handleShowPassword}
            />
          ))}
        {!!error && <span className="text-xs text-error mt-1">{error}</span>}
      </div>
    );
  }
);
Input.displayName = "Input";

export { Input };
