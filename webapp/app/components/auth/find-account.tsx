"use client";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useFormik } from "formik";
import Link from "next/link";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { ArrowRight } from "lucide-react";
import * as yup from "yup";
import AuthWrapper from "./auth-wrapper";
import { useRouter } from "next/navigation";
import { DictionaryType } from "@/types";
import { phoneRegExp } from "@/constants/regex";

const validationSchema = yup.object({
  ssnDigits: yup
    .string()
    .matches(/^\d{4}$/, "Must be a 4-digit number")
    .required("Last 4 digits of SSN or tax ID is required"),
  phone: yup
    .string()
    .matches(phoneRegExp, "Primary phone number is not valid")
    .required("Primary phone number is required"),
  accountNumber: yup
    .string()
    .matches(/^\d{9,18}$/, "Account number is not valid")
    .required("Account number is required"),
  hasZip: yup.boolean(),
  zipCode: yup
    .string()
    .matches(/^\d{5}(?:[-\s]\d{4})?$/, "Zip code is not valid")
    .when("hasZip", (hasZip, schema) =>
      hasZip?.[0] ? schema.required("Zip code is required") : schema.optional()
    ),
});

export default function FindAccount({
  dictionary,
}: {
  dictionary: DictionaryType;
}) {
  const router = useRouter();

  const formik = useFormik({
    initialValues: {
      ssnDigits: "",
      phone: "",
      accountNumber: "",
      hasZip: false,
      zipCode: "",
    },
    validationSchema,
    onSubmit: async (values) => {
      console.log(values);
      router.push("/account-type");
    },
  });

  const { ssnDigits, accountNumber, phone, zipCode, hasZip } = formik.values;
  const {
    accountNumber: accountNumberError,
    ssnDigits: ssnDigitsError,
    phone: phoneError,
    zipCode: zipCodeError,
  } = formik.errors;
  const {
    accountNumber: accountNumberTouched,
    ssnDigits: ssnDigitsTouched,
    phone: phoneTouched,
    zipCode: zipCodeTouched,
  } = formik.touched;

  return (
    <AuthWrapper title={"FIND YOUR ACCOUNT"}>
      <p className="text-black text-sm mt-[0.62rem] leading-[1.4rem] font-sans font-normal tracking-[0.03125rem]">
        If you are a Centric Utilities customer, register today for easy online
        access to your account. It&apos;s a fast and convenient way to pay your
        bill, report an outage, monitor your usage, and so much more.
      </p>
      <p className="text-black text-sm mt-[0.62rem] leading-[1.4rem] font-sans font-normal tracking-[0.03125rem]">
        Register using the phone number associated with your account{" "}
      </p>
      <p className=" text-gray-mid font-sans text-xs font-normal leading-[0.975rem] mt-[1.88rem]">
        <span className="text-error font-bold mr-1">*</span>Required fields
      </p>
      <form onSubmit={formik.handleSubmit}>
        <div className="my-6">
          <Input
            required
            name="phone"
            id="phone"
            placeholder="Primary Phone Number"
            label="Primary Phone Number"
            autoComplete="off"
            error={phoneTouched && phoneError ? phoneError : undefined}
            value={phone}
            onChange={formik.handleChange}
          />
        </div>
        <div className="my-6">
          <Input
            required
            label="Last 4 Digits of SSN or Tax ID"
            inputMode="numeric"
            type="number"
            name="ssnDigits"
            id="ssnDigits"
            placeholder="Last 4 Digits of SSN or Tax ID"
            error={
              ssnDigitsTouched && ssnDigitsError ? ssnDigitsError : undefined
            }
            value={ssnDigits}
            onChange={formik.handleChange}
          />
        </div>
        <div className="relative mt-8">
          <hr className="border-[#D6CCF1] border-[0.125rem]" />
          <span className="absolute left-1/2 text-base leading-[1.6rem] font-bold -translate-x-1/2 bg-white top-[-12px] px-2">
            OR
          </span>
        </div>
        <p className="text-black text-sm mt-[1.5rem] leading-[1.4rem] font-sans font-normal tracking-[0.03125rem]">
          Register using the account number associated with your account{" "}
        </p>
        <div className="my-8">
          <Input
            required
            name="accountNumber"
            id="accountNumber"
            placeholder="Account Number"
            label="Account Number"
            autoComplete="off"
            error={
              accountNumberTouched && accountNumberError
                ? accountNumberError
                : undefined
            }
            type="number"
            inputMode="numeric"
            value={accountNumber}
            onChange={formik.handleChange}
          />
        </div>
        <RadioGroup
          defaultValue="ssn"
          className="flex"
          onValueChange={(val: "ssn" | "zip") => {
            if (val === "zip") formik.setFieldValue("hasZip", true);
            else formik.setFieldValue("hasZip", false);
          }}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="ssn" id="ssn" />
            <label htmlFor="ssn" className="text-black text-base leading-[1.6rem] font-sans font-normal tracking-[0.03125rem]">Use my SSN or Tax ID</label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="zip" id="zip" className="ml-4" />
            <label htmlFor="zip" className="text-black text-base leading-[1.6rem] font-sans font-normal tracking-[0.03125rem]">Use Zip Code</label>
          </div>
        </RadioGroup>
        {hasZip && (
          <div className="my-8">
            <Input
              required
              name="zipCode"
              id="zipCode"
              type="number"
              inputMode="numeric"
              placeholder="Zip Code"
              label="Zip Code"
              autoComplete="off"
              error={zipCodeTouched && zipCodeError ? zipCodeError : undefined}
              value={zipCode}
              onChange={formik.handleChange}
            />
          </div>
        )}

        <Button type="submit" className="mt-12 text-base leading-[1.6rem] font-sans font-bold tracking-[0.03125rem]">
          NEXT <ArrowRight className="ml-3 h-6 w-6"/>
        </Button>
        <div className="text-xs leading-[1.2rem] font-sans font-semibold tracking-[0.0625rem] text-center mt-8">
          Already have an account?{" "}
          <Link href="/login" className="text-primary underline underline-offset-auto decoration-solid decoration-auto">
            Log In
          </Link>
        </div>
      </form>
    </AuthWrapper>
  );
}
