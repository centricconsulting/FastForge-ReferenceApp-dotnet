import CreateAccount from "@/app/components/auth/create-account";
import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";

export default async function CreateAccountPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <CreateAccount dictionary={dictionary} />;
}
