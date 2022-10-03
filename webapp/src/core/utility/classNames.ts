import { Optional } from "../types";
export const classNames: (
  ...classes: Optional<string | boolean | null>[]
) => string = (...classes) => {
  return classes.filter(Boolean).join(" ");
}; 
 