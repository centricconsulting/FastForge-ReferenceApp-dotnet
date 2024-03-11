"use client";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { LoaderIcon } from "lucide-react";
import { Dispatch, SetStateAction } from "react";

interface Props {
  setOpen: Dispatch<SetStateAction<boolean>>;
  open: boolean;
  title?: string;
  subTitle?: string;
}

export default function LoadingWithBackground({
  setOpen,
  open,
  title,
  subTitle,
}: Props) {
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent withBackground>
        <DialogHeader>
          <DialogDescription className=" text-center font-bold text-gray-dark">
            <LoaderIcon className="m-auto text-primary mb-8" size={42} />
            <p className="text-2xl">
              {title ?? "One moment, we’ll redirect you..."}
            </p>

            {subTitle && <p className="text-base mt-4">{subTitle}</p>}
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
}
