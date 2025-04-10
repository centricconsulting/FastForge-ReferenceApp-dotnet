import { Button } from "@/components/ui/button";
import { BillDetails, DictionaryType } from "@/types";

const CurrentBill = ({
  dictionary,
  billDetails,
  setShowBillDetails,
}: {
  dictionary: DictionaryType;
  billDetails: BillDetails;
  setShowBillDetails?: (showBillDetails: boolean) => void;
}) => {
  const { fromDate, toDate, dueDate, dueAmount } = billDetails;
  return (
    <div className="w-[49%] p-[24px] bg-white">
      <h1 className="text-2xl leading-9 font-poppins font-bold  text-black tracking-[1px] ">
        {dictionary.billings.current_bill}
      </h1>
      <div className="w-12 h-1 bg-[#FDB825] mt-2 mb-[24px]" />
      <p className="font-normal text-black text-lg leading-[28.8px] font-sans">
        {`${dictionary.billings.utility_service} ${fromDate} - ${toDate}`}
      </p>

      <div className="flex w-full justify-between mt-[16px]">
        <p className="font-bold text-black text-[20px] leading-[30px] font-poppins">
          {`${dictionary.billings.due_on} ${dueDate}`}
        </p>
        <div>
          <p className="font-bold text-black text-[20px] leading-[30px] font-poppins">
            {dictionary.billings.total_amount_due}
          </p>
          <p className="font-bold text-black text-[20px] leading-[30px] font-poppins">
            {dueAmount}
          </p>
        </div>
      </div>
      <div className="flex w-full justify-between mt-[16px]">
        <Button
          type="button"
          onClick={() => { setShowBillDetails?.(true); }}
          className="mt-6 w-5/12 uppercase font-bold text-base tracking-[0.5px] disabled:bg-[#D6CCF1] disabled:opacity-100"
          variant={"outline"}
        >
          {dictionary.billings.view_details}
        </Button>
        <Button
          type="button"
          // onClick={() => {}}
          className="mt-6 w-5/12 uppercase font-bold text-base tracking-[0.5px] disabled:bg-[#D6CCF1] disabled:opacity-100"
        >
          {dictionary.billings.make_payment}
        </Button>
      </div>
    </div>
  );
};

export default CurrentBill;
