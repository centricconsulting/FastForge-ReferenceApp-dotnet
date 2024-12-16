import { ReactNode } from "react";

export default function AuthWrapper({
  children,
  title,
}: {
  children: ReactNode;
  title?: string;
}) {
  return (
    <div className="h-screen grid grid-cols-1 md:grid-cols-2 gap-4">
      <div className="flex flex-col px-8 md:px-16 md:pl-[112px] py-16 mt-14">
        {!!title && (
          <h1 className="text-[2rem] leading-[3rem] tracking-[1px] font-bold font-poppins">
            {title}
          </h1>
        )}
        {children}
      </div>
      <div className="bg-[url('/images/login-bg.png')] bg-cover bg-no-repeat w-full h-full bg-center md:block hidden" />
    </div>
  );
}
