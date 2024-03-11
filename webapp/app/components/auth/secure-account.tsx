"use client";

import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { useFormik } from "formik";
import { ChevronRight, Loader2Icon, Phone } from "lucide-react";
import dynamic from "next/dynamic";
import Image from "next/image";
import { Dispatch, SetStateAction, useCallback, useState } from "react";
import * as yup from "yup";
const VerificationInput = dynamic(() => import("react-verification-input"), {
  loading: () => <Loader2Icon />,
});
const LoadingWithBackground = dynamic(
  () => import("../loading-with-background"),
  {
    loading: () => <Loader2Icon />,
  }
);

interface Props {
  setOpen: Dispatch<SetStateAction<boolean>>;
  open: boolean;
}

const validationSchema = yup.object({
  phone: yup.string().required("Phone is required"),
});

export default function SecureAccount({ setOpen, open }: Props) {
  const [contactType, setContactType] = useState(1);
  const [openLoading, setOpenLoading] = useState(false);
  const [showCode, setShowCode] = useState(false);
  const [code, setCode] = useState("");

  const formik = useFormik({
    initialValues: {
      phone: "",
    },
    validationSchema,
    onSubmit: (values) => {
      console.log(values);
      setShowCode(true);
    },
  });

  const handleCloseModal = useCallback(() => {
    if (showCode) setShowCode(false);
    else setOpen(false);
  }, [setOpen, showCode]);

  const { phone } = formik.values;
  const { phone: phoneError } = formik.errors;
  const { phone: phoneTouched } = formik.touched;

  return (
    <>
      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="max-w-[580px]">
          <DialogHeader>
            <h1 className="text-3xl font-poppins font-bold text-center text-gray-dark">
              Secure Your Account
            </h1>
          </DialogHeader>
          <div className=" text-center px-4">
            <p className="text-lg text-gray-dark mt-10 font-bold ">
              {showCode
                ? "Confirm Your Phone Number"
                : "Receive authentication via phone"}
            </p>
            <p className="text-base text-[#404041] mt-4">
              {showCode
                ? `Please enter the 6 digits code  sent to ${phone}`
                : " Be sure to use a phone number you have access to whenever you plan to sign in"}
            </p>
            {showCode ? (
              <>
                <VerificationInput
                  classNames={{
                    character:
                      "border-[#D6CCF1] rounded-[5px]  w-[70px] h-[70px] flex items-center justify-center",
                    container: "w-full text-center my-8",
                    characterInactive: "bg-white",
                  }}
                  placeholder=""
                  value={code}
                  onChange={(e) => setCode(e)}
                />
                <p className="mt-6 text-gray-dark">
                  Text or data rates may apply.
                </p>
                <Button
                  disabled={!code || code.length !== 6}
                  type="button"
                  onClick={() => {
                    setOpenLoading(true);
                    setShowCode(false);
                    setOpen(false);
                  }}
                  className="mt-6"
                >
                  NEXT <ChevronRight />
                </Button>
              </>
            ) : (
              <>
                <div className="grid grid-cols-2 gap-6 my-8">
                  <div
                    className={`border ${
                      contactType === 1
                        ? "border-primary bg-[#F0ECFA]"
                        : "border-primary-foreground"
                    } flex flex-col justify-center items-center p-4 rounded-md text-gray-dark cursor-pointer`}
                    onClick={() => setContactType(1)}
                  >
                    <Image
                      className="mb-2"
                      src="/images/text.svg"
                      alt="Text"
                      width={80}
                      height={80}
                    />
                    Text Me
                  </div>
                  <div
                    className={`border ${
                      contactType === 2
                        ? "border-primary bg-[#F0ECFA]"
                        : "border-primary-foreground"
                    } flex flex-col justify-center items-center p-4 rounded-md text-gray-dark cursor-pointer`}
                    onClick={() => setContactType(2)}
                  >
                    <Image
                      src="/images/call.svg"
                      alt="Call"
                      width={85}
                      height={82}
                      className="mb-2"
                    />
                    Call Me
                  </div>
                </div>
                <form onSubmit={formik.handleSubmit} className="mt-8">
                  <Input
                    name="phone"
                    id="phone"
                    placeholder="Your Phone Number"
                    label="Your Phone Number"
                    autoComplete="off"
                    error={phoneTouched && phoneError ? phoneError : undefined}
                    value={phone}
                    onChange={formik.handleChange}
                    icon={<Phone className="text-gray-mid" size={18} />}
                  />
                  <p className="mt-6 text-gray-dark font-bold">
                    Text or data rates may apply.
                  </p>
                  <Button type="submit" className="mt-6">
                    Continue <ChevronRight />
                  </Button>
                </form>
              </>
            )}

            <Button
              variant={"outline"}
              type="button"
              className="mt-4"
              onClick={handleCloseModal}
            >
              Go Back
            </Button>
          </div>
        </DialogContent>
      </Dialog>
      {openLoading && (
        <LoadingWithBackground
          title="Thanks for verifying it’s you!"
          subTitle="One moment, we’re logging you in..."
          open={openLoading}
          setOpen={setOpenLoading}
        />
      )}
    </>
  );
}
