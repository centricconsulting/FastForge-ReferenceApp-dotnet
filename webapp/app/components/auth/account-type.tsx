"use client";

import { Button } from "@/components/ui/button";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { DictionaryType } from "@/types";
import { useFormik } from "formik";
import { ChevronRight } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import * as yup from "yup";
import SuccessPopper from "../success-popper";
import AuthWrapper from "./auth-wrapper";

const validationSchema = yup.object({
  accountType: yup.string(),
});

export default function AccountType({
  dictionary,
}: {
  dictionary: DictionaryType;
}) {
  const [openSuccessPopper, setOpenSuccessPopper] = useState(false);

  const formik = useFormik({
    initialValues: {
      accountType: "commercial",
    },
    validationSchema,
    onSubmit: async (values) => {
      console.log(values);
      setOpenSuccessPopper(true);
    },
  });

  return (
    <AuthWrapper title={"Account Type"}>
      <p className="text-xs mt-6 text-gray-mid">
        <span className="text-error mr-1">*</span>Required fields
      </p>
      <p className="font-bold text-gray-dark text-base my-6">
        Is this a commercial or residential account?*
      </p>
      <form onSubmit={formik.handleSubmit}>
        <RadioGroup
          value={formik.values.accountType}
          className="flex"
          onValueChange={(val: "residential" | "commercial") => {
            formik.setFieldValue("accountType", val);
          }}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="commercial" id="commercial" />
            <label htmlFor="commercial">{dictionary.auth.commercial}</label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem
              value="residential"
              id="residential"
              className="ml-4"
            />
            <label htmlFor="residential">{dictionary.auth.residential}</label>
          </div>
        </RadioGroup>

        <Button type="submit" className="mt-12">
          NEXT <ChevronRight />
        </Button>
        <div className="text-xs font-bold text-center mt-8">
          Already have an account?{" "}
          <Link href="/login" className="text-primary">
            Log In
          </Link>
        </div>
      </form>
      {openSuccessPopper && (
        <SuccessPopper
          open={openSuccessPopper}
          setOpen={setOpenSuccessPopper}
        />
      )}
    </AuthWrapper>
  );
}
