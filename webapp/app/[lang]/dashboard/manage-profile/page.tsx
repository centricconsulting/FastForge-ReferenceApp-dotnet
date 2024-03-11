import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Manage Profile",
};

export default async function ManageProfilePage() {
  return (
    <div className="w-full">
      <div className="flex w-full items-center justify-between">
        <h1 className="text-2xl">Manage Profile</h1>
      </div>
    </div>
  );
}
