import Login from "@/app/components/auth/login";
import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";

export default async function LoginPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <Login dictionary={dictionary} />;
}
