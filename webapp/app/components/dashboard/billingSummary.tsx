import { BillDetails, DictionaryType } from "@/types";




const TableView = ({
  data,
}: {
  data: Record<string, { units: string; charge: string }>;
}) => {
  return Object.keys(data)?.map((item, index) => {
    const unit = data[item]?.units;
    const charge = data[item]?.charge;
    return (
      <div
        key={index}
        className="flex flex-wrap w-full justify-between mt-[16px]"
      >
        <div className="flex-1 ">
          <div className="font-sans font-normal text-base">{item}</div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-normal text-base">{unit}</div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-normal text-base">{charge}</div>
        </div>
      </div>
    );
  });
};

const BillingSummary = ({
  dictionary,
  billDetails,
}: {
  dictionary: DictionaryType;
  billDetails: BillDetails;
}) => {
  const { fromDate, toDate } = billDetails;
  return (
    <div className="w-[49%] p-[24px] bg-white">
      <h1 className="text-2xl leading-9 font-poppins font-bold  text-black tracking-[1px]">
        {dictionary.billings.summary}
      </h1>
      <div className="w-12 h-1 bg-[#FDB825] mt-2 mb-[24px]" />
      <p className="font-normal text-black text-lg leading-[28.8px] font-sans">
        {`${dictionary.billings.utility_service} ${fromDate} - ${toDate}`}
      </p>
      {billDetails?.billCharges && (
        <>
          <div className="flex flex-wrap w-full justify-between mt-[16px]">
            <div className="flex-1 ">
              <div className="font-sans font-bold">Description</div>
            </div>
            <div className="flex-1 ">
              <div className="font-sans font-bold">Units</div>
            </div>
            <div className="flex-1 ">
              <div className="font-sans font-bold">Charge</div>
            </div>
          </div>
          <TableView data={billDetails?.billCharges} />
        </>
      )}
      <div className="flex flex-wrap w-full justify-between mt-[16px]">
        <div className="flex-1 ">
          <div className="font-sans font-bold">SubTotal</div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-bold"></div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-bold">{billDetails?.subTotal}</div>
        </div>
      </div>
      <div className="border-b-2 border-black mt-[16px]"></div>
      {billDetails?.billTaxes && <TableView data={billDetails?.billTaxes} />}
      <div className="border-b-2 border-black mt-[16px]"></div>
      <div className="flex flex-wrap w-full justify-between mt-[16px]">
        <div className="flex-1 ">
          <div className="font-sans font-bold">Total</div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-bold"></div>
        </div>
        <div className="flex-1 ">
          <div className="font-sans font-bold">{billDetails?.dueAmount}</div>
        </div>
      </div>
    </div>
  );
};

export default BillingSummary;
