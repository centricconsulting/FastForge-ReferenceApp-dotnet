import Image from "next/image";
import LocaleSwitcher from "./locale-switcher";
import { Locale } from "@/i18n-config";

export default async function Header({ lang }: { lang: Locale }) {
  return (
    <header className="h-[60px] w-full py-1 px-4 md:px-16 flex justify-between items-center max-w-screen-2xl m-auto  shadow-[inset_0px_-1px_0px_0px_#66666614]">
      <Image width={137} height={52} src="/images/logo.jpg" alt="logo" />
      <LocaleSwitcher lang={lang} />
    </header>
  );
}
