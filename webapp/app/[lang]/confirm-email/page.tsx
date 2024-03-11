import ConfirmEmail from "@/app/components/auth/confirm-email";
import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";

export default async function ConfirmEmailPage({
  params: { lang },
}: {
  params: { lang: Locale };
}) {
  const dictionary = await getDictionary(lang);

  return <ConfirmEmail dictionary={dictionary} />;
}
