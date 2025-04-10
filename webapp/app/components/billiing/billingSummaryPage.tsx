"use client";
import { BillDetails, DictionaryType } from "@/types";
import CurrentBill from "../dashboard/currentBill";
import BillingSummary from "../dashboard/billingSummary";
import { useState } from "react";
import MonthlyBillingHistory from "../billing/MonthlyBillingHistory";

const BillingSummaryPage = ({
  dictionary,
  billDetails,
  billHistoryData,
}: {
  dictionary: DictionaryType;
  billDetails: BillDetails;
  billHistoryData: any;
}) => {
  const [showBillDetails, setShowBillDetails] = useState(false);

  return (
    <>
      <h1 className="text-3xl font-poppins font-bold  text-black mb-[24px] mt-[24px] ">
        {showBillDetails
          ? dictionary.billings.billingDetails
          : dictionary.billings.payMyBills}
      </h1>
      <div className="flex flex-row  w-full  justify-between">
        {billDetails && (
          <>
            <CurrentBill
              dictionary={dictionary}
              billDetails={billDetails}
              setShowBillDetails={setShowBillDetails}
            />
            {showBillDetails ? (
              <BillingSummary
                dictionary={dictionary}
                billDetails={billDetails}
              />
            ) : (
              <MonthlyBillingHistory
                billHistoryData={billHistoryData}
                dictionary={dictionary}
              />
            )}
          </>
        )}
      </div>
    </>
  );
};

export default BillingSummaryPage;
