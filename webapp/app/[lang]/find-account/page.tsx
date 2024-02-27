import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";
import FindAccount from "../components/auth/find-account";

export default async function FindAccountPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <FindAccount dictionary={dictionary} />;
}
