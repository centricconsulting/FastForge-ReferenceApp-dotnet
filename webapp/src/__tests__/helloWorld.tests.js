import { act } from "react-dom/test-utils";

beforeEach(() => { console.log("executing beforeEach"); });
afterEach(() => { console.log("executing afterEach"); });

it("hello, world!", () =>{
	act(() => { console.log("acting"); });
	expect(true).toBe(true);
});