import { ReactNode } from "react";

export default function AuthWrapper({
  children,
  title,
}: {
  children: ReactNode;
  title?: string;
}) {
  /* <p>
        This text is rendered on the server:{" "}
        {dictionary["server-component"].welcome}
      </p>
   */

  return (
    <div className="  h-screen grid grid-cols-1 md:grid-cols-2 gap-4">
      <div className="flex flex-col justify-center px-8 md:px-16">
        {!!title && <h1 className="text-3xl font-bold"> {title}</h1>}
        {children}
      </div>
      <div className="bg-[url('/images/login-bg.png')] bg-cover bg-no-repeat w-full h-full bg-center md:block hidden" />
    </div>
  );
}
