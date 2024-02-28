"use client";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { CheckCircle } from "lucide-react";
import { Dispatch, SetStateAction } from "react";

interface Props {
  setOpen: Dispatch<SetStateAction<boolean>>;
  open: boolean;
}

export default function SuccessPopper({ setOpen, open }: Props) {
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent>
        <DialogHeader>
          <DialogDescription className="text-lg text-center font-bold text-gray-dark">
            <CheckCircle className="text-success m-auto mb-8" size={"48px"} />
            We found your account
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
}
