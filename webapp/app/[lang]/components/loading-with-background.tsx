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
}

export default function LoadingWithBackground({ setOpen, open }: Props) {
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent withBackground>
        <DialogHeader>
          <DialogDescription className="text-lg text-center font-bold text-gray-dark">
            <LoaderIcon className="m-auto text-primary mb-8" />
            One moment, we’ll redirect you...
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
}
