import { AxiosError } from "axios";

const getCatch = (
  err: AxiosError
): { message: string; status?: number; type?: string } => {
  // ---------------------------------------- for custom generated errors
  if (err.response && err.response.data) {
    return { message: err.response.data?.error || "System Error " };
  }
  // ---------------------------------------- offline error
  else if (!window.navigator.onLine) {
    return { message: "No Internet Connection  " };
  }
  // unknown errors
  else {
    return { message: "Internal Server Error" };
  }
};

export { getCatch };
