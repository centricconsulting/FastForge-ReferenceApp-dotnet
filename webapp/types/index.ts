import { type getDictionary } from "@/get-dictionary";

export type DictionaryType = Awaited<ReturnType<typeof getDictionary>>;

export type BillDetails = {
    customerId: number;
    fromDate: string;
    toDate: string;
    dueDate: string;
    dueAmount: string;
    billCharges?: Record<string, { units: string; charge: string }>;
    billTaxes?: Record<string, { units: string; charge: string }>;
    subTotal: string;
  };
