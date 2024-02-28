import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";
import ConfirmEmail from "../components/auth/confirm-email";

export default async function ConfirmEmailPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <ConfirmEmail dictionary={dictionary} />;
}
