"use client";

import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { useFormik } from "formik";
import Link from "next/link";

import * as yup from "yup";
import AuthWrapper from "./auth-wrapper";

const validationSchema = yup.object({
  username: yup.string().email("Invalid email").required("Email is required"),
  password: yup.string().required("Password is required"),
});

export default function Login({ dictionary }: { dictionary: any }) {
  const formik = useFormik({
    initialValues: {
      email: "",
      password: "",
    },
    validationSchema,
    onSubmit: async (values) => {
      console.log(values);
    },
  });

  const { password, email } = formik.values;
  const { email: emailError, password: passwordError } = formik.errors;
  const { email: emailTouched, password: passwordTouched } = formik.touched;

  return (
    <AuthWrapper title={dictionary.auth.login}>
      <form onSubmit={formik.handleSubmit}>
        <div className="my-8">
          <Input
            name="email"
            id="email"
            placeholder="Email"
            label="EMAIL"
            autoComplete="off"
            error={emailTouched && emailError ? emailError : undefined}
            value={email}
            onChange={formik.handleChange}
          />
        </div>
        <div className="my-8">
          <Input
            label="Password"
            type="password"
            name="password"
            id="password"
            placeholder="Password"
            error={passwordTouched && passwordError ? passwordError : undefined}
            value={password}
            onChange={formik.handleChange}
          />
        </div>
        <Checkbox id="terms" />
        <label
          htmlFor="terms"
          className="text-base font-semibold ml-2 leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 "
        >
          Remember my email on this device
        </label>
        <div className="flex flex-col items-end">
          <Link
            className="text-xs font-bold text-primary mb-4 mt-8"
            href="/forget-password"
          >
            Forgot Email?
          </Link>
          <Link
            className="text-xs font-bold text-primary"
            href="/forget-password"
          >
            Forgot Password?
          </Link>
        </div>

        <Button type="submit" className="mt-12">
          {dictionary.auth.login}
        </Button>
        <div className="text-xs font-bold text-center mt-8">
          Don’t have an account?{" "}
          <Link href="/find-account" className="text-primary">
            Register
          </Link>
        </div>
      </form>
    </AuthWrapper>
  );
}
