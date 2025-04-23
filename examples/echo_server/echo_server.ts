// Newer versions of the Standard Library are now hosted on JSR.
// Older versions up till 0.224.0 are still available at deno.land/std.
// import { copy } from "https://deno.land/std@0.224.0/fs/copy.ts";
import { copy } from "@std/fs";

const hostname = "0.0.0.0";  // "localhost";
const port = 8080;
const listener = Deno.listen({ hostname, port });
console.log(`Listening on ${hostname}:${port}`);
for await (const conn of listener) {
  //copy(conn, "./tmp");
  conn.readable.pipeTo(conn.writable);
}
