// page 34
import { serve } from "./deps.ts"

/*
for await (const req of serve(":8080")) {
  req.respond({ body: "Hello deno" })
}
*/
const port = Deno.args.length > 0 ? Number(Deno.args[0]) : 8080;
serve((req: Request) => new Response('Hello deno'), { port: port });
