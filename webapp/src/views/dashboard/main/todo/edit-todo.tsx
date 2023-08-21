import React, {useEffect} from "react";
import { useFormik } from "formik";
import * as yup from "yup";
import { useActions, useTypedSelector } from "../../../../core/hooks";
import { SecondaryButton } from "../../../../core/components/secondaryButton";
import {useSearchParams} from "react-router-dom";

const EditTodo = () => {
   let [searchParams] = useSearchParams();
  const _id = searchParams.get("_id");
  const { editTodo, fetchOneTodo } = useActions();
  const { loading, item } = useTypedSelector((state) => state.todo);
  const formik = useFormik({
    enableReinitialize: true,  
    initialValues: {
      title: item?.title ?? "",
      description: item?.description ?? "",
      isUrgent: item?.isUrgent ?? false, 
    },
    validationSchema: yup.object({
      title: yup
        .string()
        .max(20, "title is too long")
        .required("title is required"),
      description: yup
        .string()
        .max(500, "description can't be more than 500")
        .min(10, "description should be at least 10 characters long")
        .required("description is required"),
        isUrgent: yup.bool(),
    }),
    onSubmit: ({ title, description, isUrgent }) => { 
    
      editTodo(
           {
          title,
          description,
          isUrgent,  
        
        },
        item?.id ?? "");
    },
  });
 
   useEffect(() => {
    if (_id) {
      fetchOneTodo(_id);
    }
  }, [_id]);  

  const { title, description, isUrgent } = formik.values;
  const { title: titleError, description: descriptionError } = formik.errors;
  const { title: titleTouched, description: descriptiontouched } =
    formik.touched;

  return (
    <>
      <div className="form-wrapper"> 
       <h5 className="title">Edit Todo</h5>
        <form onSubmit={formik.handleSubmit}>
          <div className="container text-center">

            <div className="row">
              <div className="col-12 col-md-6 col-lg-6 ">
                {" "}
                <label
                  htmlFor="exampleInputEmail1"
                  className="form-label w-100 text-left"
                >
                  Title
                </label>
                <input
                  type="text"
                  name="title"
                  className="form-control"
                  id="exampleInputEmail1"
                  aria-describedby="emailHelp"
                  value={title}
                  onChange={formik.handleChange}
                />
                {titleTouched && titleError && (
                  <p className="input-error">{titleError}</p>
                )}
              </div>
              <div className="col-12 col-md-6 col-lg-6 ">
                {" "}
                <label htmlFor="title" className="form-label w-100 text-left">
                  description
                </label>
                <input
                  name="description"
                  type="text"
                  className="form-control"
                  id="description"
                  value={description}
                  onChange={formik.handleChange}
                />
                {descriptiontouched && descriptionError && (
                  <p className="input-error">{descriptionError}</p>
                )}
              </div>
              <div className="col-12  col-lg-12 text-end align-self-end pt-2">
                {" "}
                <input
                  type="checkbox"
                  name="isUrgent"
                  className="form-check-input"
                  id="exampleCheck1"
                  checked={isUrgent}
                  onChange={(e) => {
                    formik.setFieldValue("isUrgent", e.target.checked, true);
                  }}
                />
                <label className="form-check-label" htmlFor="exampleCheck1">
                  urgent
                </label>
              </div>
            </div>
            <div className="row">
              <div className="col-12  mt-4">
                <SecondaryButton title="Submit" />
              </div>
            </div>
          </div>
        </form>
      </div>
    </>
  );
};

export { EditTodo };
