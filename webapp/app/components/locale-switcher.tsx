"use client";

import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { ChevronDown } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { i18n, type Locale } from "../../i18n-config";

export default function LocaleSwitcher({ lang }: { lang: Locale }) {
  const pathName = usePathname();
  const redirectedPathName = (locale: Locale) => {
    if (!pathName) return "/";
    const segments = pathName.split("/");
    segments[1] = locale;
    return segments.join("/");
  };

  return (
    <div>
      <Popover>
        <PopoverTrigger>
          <div className="flex items-center text-gray-dark text-lg font-bold">
            {lang}
            <ChevronDown className="ml-2" />
          </div>
        </PopoverTrigger>
        <PopoverContent>
          <ul>
            {i18n.locales.map((locale) => {
              return (
                <li key={locale}>
                  <Link href={redirectedPathName(locale)}>{locale}</Link>
                </li>
              );
            })}
          </ul>
        </PopoverContent>
      </Popover>
    </div>
  );
}
