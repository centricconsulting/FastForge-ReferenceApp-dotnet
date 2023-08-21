export type Input = string | number | undefined | null;
export type Optional<T> = T | undefined; 
export type InputObject<T = any> = { [key: string]: T }; 
export type DeleteType<T extends InputObject> = { data: T }; 
export type QueryParams = {
  limit?: number;
  page?: number;
  createdAt?: Date;
  updatedAt?: Date;
  status?: string;
} & { [key in string]: Input };
