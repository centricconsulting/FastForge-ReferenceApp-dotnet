import { AxiosRequestConfig } from "axios";
import { Dispatch } from "react";
import { customizedAxios } from "../../config";
import { QueryParams, TodoType } from "../../types";
import { TodoActionTypes } from "../actionTypes";
import { BASE_API, TODO_API } from "../api";
import { TODO_TYPES } from "../types";

export const fetchTodos =
  ({ limit, page }: QueryParams) =>
  async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {
        headers: {
          // Authorization: ``,
        },
        params: {
          limit,
          page,
        },
      };

      let url = TODO_API;
      const res = await customizedAxios.get<TodoType[]>(url, config);
      dispatch({
        type: TODO_TYPES.TODO_LIST,
        payload: res.data,
      });
    } catch (err: any) {
      // const { message } = getCatch(err);
      // window.openToastError(message);
    } finally {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };

export const addTodo =
  (body: TodoType) => async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {
        headers: {
          // Authorization: `Bearer ${store.getState().auth.token}`, // if you have a token, put it here
        },
      };

      let url = TODO_API;
      await customizedAxios.post(url, body, config);

      dispatch({
        type: TODO_TYPES.DISABLE_LOADING,
      });
      window.openToastSuccess("Todo was added successfully");
      window.navigate(-1);
    } catch (err: any) {
      // const { message } = getCatch(err);
      // window.openToastError(message);

      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };
