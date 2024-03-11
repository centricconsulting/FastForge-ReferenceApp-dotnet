import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Usage",
};

export default async function UsagePage() {
  return (
    <div className="w-full">
      <div className="flex w-full items-center justify-between">
        <h1 className="text-2xl">Usage </h1>
      </div>
    </div>
  );
}
