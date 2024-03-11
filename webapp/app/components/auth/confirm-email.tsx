"use client";

import { Button } from "@/components/ui/button";
import AuthWrapper from "./auth-wrapper";
import { DictionaryType } from "@/types";

export default function ConfirmEmail({
  dictionary,
}: {
  dictionary: DictionaryType;
}) {
  return (
    <AuthWrapper title={"Please Confirm Your Email"}>
      <p className=" text-black text-base my-6">
        Thanks for creating an account. You’re almost done!
        <br /> In a few minutes, you’ll receive an email with a confirmation
        link. Please confirm your email to complete your account set up.
      </p>

      <Button type="submit" className="mt-12">
        BACK TO LOG IN
      </Button>
    </AuthWrapper>
  );
}
