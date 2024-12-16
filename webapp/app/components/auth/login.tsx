"use client";

import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { useFormik } from "formik";
import Link from "next/link";

import * as yup from "yup";
import AuthWrapper from "./auth-wrapper";
import { useState } from "react";
import dynamic from "next/dynamic";
import { Loader2Icon } from "lucide-react";
import { DictionaryType } from "@/types";
const SecureAccount = dynamic(() => import("./secure-account"), {
  loading: () => <Loader2Icon />,
});

const validationSchema = yup.object({
  email: yup.string().email("Invalid email").required("Email is required"),
  password: yup.string().required("Password is required"),
});

export default function Login({ dictionary }: { dictionary: DictionaryType }) {
  const [openSecureAccount, setOpenSecureAccount] = useState(false);

  const formik = useFormik({
    initialValues: {
      email: "",
      password: "",
    },
    validationSchema,
    onSubmit: (values) => {
      console.log(values);
      setOpenSecureAccount(true);
    },
  });

  const { password, email } = formik.values;
  const { email: emailError, password: passwordError } = formik.errors;
  const { email: emailTouched, password: passwordTouched } = formik.touched;

  return (
    <>
      <AuthWrapper title={dictionary.auth.login}>
        <form onSubmit={formik.handleSubmit}>
          <div className="my-8">
            <Input
              name="email"
              id="email"
              placeholder={dictionary.auth.email}
              label={dictionary.auth.email}
              autoComplete="off"
              error={emailTouched && emailError ? emailError : undefined}
              value={email}
              onChange={formik.handleChange}
            />
          </div>
          <div className="my-8">
            <Input
              label={dictionary.auth.password}
              type="password"
              name="password"
              id="password"
              placeholder={dictionary.auth.password}
              error={
                passwordTouched && passwordError ? passwordError : undefined
              }
              value={password}
              onChange={formik.handleChange}
            />
          </div>
          <Checkbox id="terms" />
          <label
            htmlFor="terms"
            className="text-base font-semibold ml-2 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 tracking-[0.5px]"
          >
            {dictionary.auth.remember_my_email_on_this_device}
          </label>
          <div className="flex flex-col items-end">
            <Link
              className="text-xs font-bold tracking-[1px] text-primary mb-4 mt-8 capitalize underline underline-offset-auto decoration-solid decoration-auto"
              href="/forget-password"
            >
              {dictionary.auth.forgot_email}?
            </Link>
            <Link
              className="text-xs font-bold text-primary tracking-[1px] capitalize underline underline-offset-auto decoration-solid decoration-auto"
              href="/forget-password"
            >
              {dictionary.auth.forgot_password}?
            </Link>
          </div>

          <Button
            type="submit"
            className="mt-16 uppercase font-bold text-base tracking-[1px]"
          >
            {dictionary.auth.login}
          </Button>
          <div className="text-xs font-semibold tracking-[1px] text-center mt-8">
            {dictionary.auth["don’t_have_an_account"]}?{" "}
            <Link
              href="/find-account"
              className="text-primary underline underline-offset-auto decoration-solid decoration-auto"
            >
              {dictionary.auth.register}
            </Link>
          </div>
        </form>
      </AuthWrapper>

      <SecureAccount open={openSecureAccount} setOpen={setOpenSecureAccount} />
    </>
  );
}
