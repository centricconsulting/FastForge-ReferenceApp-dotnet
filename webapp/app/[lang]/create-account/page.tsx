import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";
import CreateAccount from "../components/auth/create-account";

export default async function CreateAccountPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <CreateAccount dictionary={dictionary} />;
}
