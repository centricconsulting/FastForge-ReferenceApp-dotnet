import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Outages",
};

export default async function OutagesPage() {
  return (
    <div className="w-full">
      <div className="flex w-full items-center justify-between">
        <h1 className="text-2xl">Outages </h1>
      </div>
    </div>
  );
}
