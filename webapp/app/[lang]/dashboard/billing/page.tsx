import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Billing",
};

export default async function BillingPage() {
  return (
    <div className="w-full">
      <div className="flex w-full items-center justify-between">
        <h1 className="text-2xl">Billing </h1>
      </div>
    </div>
  );
}
