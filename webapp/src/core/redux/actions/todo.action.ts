import { AxiosRequestConfig } from "axios";
import { Dispatch } from "react";
import { customizedAxios } from "../../config";
import { DeleteType, QueryParams, TodoType } from "../../types";
import { TodoActionTypes } from "../actionTypes";
import { TODO_API } from "../api";
import { TODO_TYPES } from "../types";

export const fetchTodos =
  (queryParams: QueryParams) => async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {
        params: queryParams,
      };

      let url = TODO_API;
      const res = await customizedAxios.get<TodoType[]>(url, config);

      const arr = res.headers?.link.split(" ");
      const index = arr.indexOf('rel="last"');

      dispatch({
        type: TODO_TYPES.TODO_LIST,
        payload: {
          list: res.data,
          pages: +arr[index - 1].split("_page=")[1].split(">;")[0] ?? 1,
        },
      });
    } catch (err: any) {
      console.log(err);
    } finally {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };

export const addTodo =
  (body: TodoType) => async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {};

      let url = TODO_API;
      await customizedAxios.post(url, body, config);

      dispatch({
        type: TODO_TYPES.DISABLE_LOADING,
      });
      window.openToastSuccess("Todo was added successfully");
      window.navigate(-1);
    } catch (err: any) {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };

export const fetchOneTodo =
  (id: string) => async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {
        headers: {},
      };

      let url = TODO_API.concat("/" + id);
      const res = await customizedAxios.get<TodoType>(url, config);
      dispatch({
        type: TODO_TYPES.TODO_ITEM,
        payload: res.data,
      });
    } catch (err: any) {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };

export const editTodo =
  (body: TodoType, id: string) =>
  async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {};

      let url = TODO_API.concat("/" + id);
      await customizedAxios.put(url, body, config);

      dispatch({
        type: TODO_TYPES.DISABLE_LOADING,
      });
      window.openToastSuccess("Todo Edited Successfully");
      window.navigate(-1);
    } catch (err: any) {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };

export const deleteTodo =
  (id: string) => async (dispatch: Dispatch<TodoActionTypes>) => {
    try {
      dispatch({ type: TODO_TYPES.TODO_LOADING });

      const config: AxiosRequestConfig = {
        headers: {},
      };

      let url = TODO_API.concat("/" + id);
      await customizedAxios.delete<DeleteType<TodoType>>(url, config);

      dispatch({
        type: TODO_TYPES.TODO_DELETE,
        payload: { todoId: id },
      });
      window.openToastSuccess("Todo Deleted");
    } catch (err: any) {
      dispatch({ type: TODO_TYPES.DISABLE_LOADING });
    }
  };
