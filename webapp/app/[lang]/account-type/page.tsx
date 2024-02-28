import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";
import AccountType from "../components/auth/account-type";

export default async function AccountTypePage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <AccountType dictionary={dictionary} />;
}
