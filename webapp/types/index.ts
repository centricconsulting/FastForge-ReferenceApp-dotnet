import { type getDictionary } from "@/get-dictionary";

export type DictionaryType = Awaited<ReturnType<typeof getDictionary>>;
