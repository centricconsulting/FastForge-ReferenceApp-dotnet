import FindAccount from "@/app/components/auth/find-account";
import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";

export default async function FindAccountPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <FindAccount dictionary={dictionary} />;
}
