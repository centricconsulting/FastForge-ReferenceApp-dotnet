"use client";

import { Locale } from "@/i18n-config";
import {
  BadgeInfo,
  BarChartBig,
  GalleryVerticalEnd,
  Home,
  User,
  Wallet2,
} from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useState } from "react";

const DRAWER_ITEMS = [
  { title: "Home", Icon: Home, link: "" },
  { title: "Manage Profile", Icon: User, link: "manage-profile" },
  { title: "Billing", Icon: Wallet2, link: "billing" },
  { title: "Outages", Icon: BadgeInfo, link: "outages" },
  { title: "Usage", Icon: BarChartBig, link: "usage" },
  { title: "Ways to Save", Icon: GalleryVerticalEnd, link: "ways-to-save" },
];

export default function Drawer({ lang }: { lang: Locale }) {
  const pathName = usePathname();

  return (
    <nav className="w-[85px] h-[calc(100vh-2px)] border-[#A3A4A6] border bg-white flex-none top-0 absolute left-0 pt-[70px] max-h-[854px]">
      <ul className="flex flex-col justify-center items-between h-full">
        {DRAWER_ITEMS.map((el, index) => {
          const { title, Icon, link } = el;

          return (
            <Link href={`/dashboard/${link}`} key={index}>
              <li
                key={title}
                className={`${
                  pathName === `/en/dashboard${link ? `/${link}` : link}` &&
                  "bg-[#F0ECFA] text-primary border-r-4 border-r-primary"
                } flex flex-col justify-center items-center h-[78px] my-[10px] text-center`}
              >
                <Icon />
                <p className="pt-2">{el.title}</p>
              </li>
            </Link>
          );
        })}
      </ul>
    </nav>
  );
}
