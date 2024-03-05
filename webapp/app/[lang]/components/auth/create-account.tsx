"use client";

import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { useFormik } from "formik";
import Link from "next/link";

import * as yup from "yup";
import AuthWrapper from "./auth-wrapper";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { DictionaryType } from "@/types";

const validationSchema = yup.object({
  firstName: yup.string().required("First name is required"),
  lastName: yup.string().required("Last name is required"),
  phone: yup.string().required("Phone is required"),
  email: yup.string().email("Invalid email").required("Email is required"),
  password: yup.string().required("Password is required"),
  confirmPassword: yup.string().required("Confirm password is required"),
});

export default function CreateAccount({
  dictionary,
}: {
  dictionary: DictionaryType;
}) {
  const [agree, setAgree] = useState(false);
  const router = useRouter();

  const formik = useFormik({
    initialValues: {
      firstName: "",
      lastName: "",
      phone: "",
      email: "",
      password: "",
      confirmPassword: "",
    },
    validationSchema,
    onSubmit: async (values) => {
      console.log(values);
      router.push("/confirm-email");
    },
  });

  const { password, email, firstName, lastName, confirmPassword, phone } =
    formik.values;
  const {
    email: emailError,
    password: passwordError,
    phone: PhoneError,
    firstName: firstNameError,
    lastName: lastNameError,
    confirmPassword: confirmPasswordError,
  } = formik.errors;
  const {
    email: emailTouched,
    password: passwordTouched,
    confirmPassword: confirmPasswordTouched,
    phone: PhoneTouched,
    firstName: firstNameTouched,
    lastName: lastNameTouched,
  } = formik.touched;

  return (
    <AuthWrapper title={"Create Your Account"}>
      <p className="text-xs mt-6 text-gray-mid">
        <span className="text-error mr-1">*</span>Required fields
      </p>
      <form onSubmit={formik.handleSubmit}>
        <div className="my-6 grid md:grid-cols-2 gap-4">
          <Input
            required
            name="firstName"
            id="firstName"
            placeholder="First Name"
            label="First Name"
            autoComplete="off"
            error={
              firstNameTouched && firstNameError ? firstNameError : undefined
            }
            value={firstName}
            onChange={formik.handleChange}
          />
          <Input
            required
            name="lastName"
            id="lastName"
            placeholder="Last Name"
            label="Last Name"
            autoComplete="off"
            error={lastNameTouched && lastNameError ? lastNameError : undefined}
            value={lastName}
            onChange={formik.handleChange}
          />
        </div>
        <div className="my-6">
          <Input
            required
            name="phone"
            id="phone"
            placeholder="Primary Phone Number"
            label="Primary Phone Number"
            autoComplete="off"
            error={PhoneTouched && PhoneError ? PhoneError : undefined}
            value={phone}
            onChange={formik.handleChange}
          />
        </div>
        <div className="my-6">
          <Input
            required
            name="email"
            id="email"
            placeholder="Email"
            label="Email"
            autoComplete="off"
            error={emailTouched && emailError ? emailError : undefined}
            value={email}
            onChange={formik.handleChange}
          />
        </div>
        <div className="my-6">
          <Input
            hint="Password must contain at least 8 characters and include at least one of each of the following: an uppercase letter, a lowercase letter, a number and a special symbol (!, @, #, $, %, ^, & or *)"
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
        <div className="my-6">
          <Input
            required
            label="Confirm Password"
            type="password"
            name="confirmPassword"
            id="confirmPassword"
            placeholder="Confirm Password"
            error={
              confirmPasswordTouched && confirmPasswordError
                ? confirmPasswordError
                : undefined
            }
            value={confirmPassword}
            onChange={formik.handleChange}
          />
        </div>
        <Checkbox
          id="terms"
          checked={agree}
          onCheckedChange={(checked: boolean) => setAgree(checked)}
        />
        <label
          htmlFor="terms"
          className="text-base font-semibold ml-2 leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 "
        >
          I agree to the{" "}
          <Link href="/" className="text-primary underline">
            Terms and Conditions
          </Link>
        </label>

        <Button disabled={!agree} type="submit" className="mt-12">
          CREATE ACCOUNT
        </Button>
      </form>
    </AuthWrapper>
  );
}
