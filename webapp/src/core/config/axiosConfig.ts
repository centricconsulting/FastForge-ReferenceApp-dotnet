import axios from "axios";
import { BASE_API } from "../redux";

export const customizedAxios = axios.create({
  baseURL: `${BASE_API}`,
  headers: {
    "Content-Type": "application/json",
  }, 
});
