import { getDictionary } from "@/get-dictionary";
import { Locale } from "@/i18n-config";
import { Metadata } from "next";
import dummyBillApi from "../../../apis/dummyBillApi";
import BillingSummaryPage from "@/app/components/billiing/billingSummaryPage";
import billingHistoryAPI from "@/app/apis/dummyMonthlyBillHistory";

export const metadata: Metadata = {
  title: "Billing",
};

export default async function BillingPage({
  params: { lang },
}: Readonly<{
  params: { lang: Locale };
}>) {
  const customerBill = dummyBillApi.getBill(123);
  const billHistoryData = billingHistoryAPI.getBillingHistory();


  const dictionary = await getDictionary(lang);
  return (
    <>
      {customerBill && (
        <BillingSummaryPage dictionary={dictionary} billDetails={customerBill} billHistoryData={billHistoryData} />
      )}
    </>
  );
}
