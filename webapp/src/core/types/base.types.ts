export type Input = string | number | undefined | null;

export type QueryParams = {
  limit?: number;
  page?: number;
  createdAt?: Date;
  updatedAt?: Date;
  status?: string;
} & { [key in string]: Input };
