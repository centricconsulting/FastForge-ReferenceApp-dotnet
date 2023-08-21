declare global {
  interface Window {
    openToastSuccess: any;
    openToastError: any;
    navigate: NavigateFunction;
  }
}

export {};
