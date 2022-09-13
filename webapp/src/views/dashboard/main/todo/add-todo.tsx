import React from "react";
import { useFormik } from "formik";
import * as yup from "yup";

const AddTodo = () => {
  const formik = useFormik({
    initialValues: {
      title: "",
      description: "",
      urgent: false,
    },
    validationSchema: yup.object({
      title: yup
        .string()
        .max(20, "title is too long")
        .min(5, "title should be at least 5 characters long")
        .required("title is required"),
      description: yup
        .string()
        .max(500, "description can't be more than 500")
        .min(10, "description should be at least 10 characters long")
        .required("description is required"),
      urgent: yup.bool(),
    }),
    onSubmit: ({ title, description, urgent }) => {
      console.log(title, description, urgent);
    },
  });

  const { title, description, urgent } = formik.values;
  const { title: titleError, description: descriptionError } = formik.errors;
  const { title: titleTouched, description: descriptiontouched } =
    formik.touched;
  return (
    <>
      <div>
        <form onSubmit={formik.handleSubmit}>
          <div className="container text-center">
            <div className="row">
              <h1>Add ToDO</h1>
            </div>
            <div className="row">
              <div className="col-12 col-md-6 col-xl-4">
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
                  <p className="input-error--select">{titleError}</p>
                )}
              </div>
              <div className="col-12 col-md-6 col-xl-4">
                {" "}
                <label
                  htmlFor="exampleInputPassword1"
                  className="form-label w-100 text-left"
                >
                  description
                </label>
                <input
                  name="description"
                  type="password"
                  className="form-control"
                  id="exampleInputPassword1"
                  value={description}
                  onChange={formik.handleChange}
                />
                {descriptiontouched && descriptionError && (
                  <p className="input-error--select">{descriptionError}</p>
                )}
              </div>
              <div className="col-12  col-xl-4  align-self-end">
                {" "}
                <input
                  type="checkbox"
                  name="urgent"
                  className="form-check-input"
                  id="exampleCheck1"
                  checked={urgent}
                  onChange={(e) => {
                    formik.setFieldValue("urgent", e.target.checked, true);
                  }}
                />
                <label className="form-check-label" htmlFor="exampleCheck1">
                  urgent
                </label>
              </div>
            </div>
            <div className="row">
              <div className="col-12  mt-4">
                <button type="submit" className="btn btn-primary w-100">
                  Submit
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </>
  );
};

export default AddTodo;
