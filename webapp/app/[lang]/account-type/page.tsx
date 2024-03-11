import AccountType from "@/app/components/auth/account-type";
import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";

export default async function AccountTypePage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <AccountType dictionary={dictionary} />;
}
