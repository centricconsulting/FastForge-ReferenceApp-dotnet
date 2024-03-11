import { Metadata } from "next";

export const metadata: Metadata = {
  title: "WaysToSavePage",
};

export default async function WaysToSavePage() {
  return (
    <div className="w-full">
      <div className="flex w-full items-center justify-between">
        <h1 className="text-2xl">WaysToSavePage </h1>
      </div>
    </div>
  );
}
