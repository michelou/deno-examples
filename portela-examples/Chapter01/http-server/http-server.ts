import { serve } from "https://deno.land/std@0.170.0/http/server.ts"

/*
for await (const req of serve(":8080")) {
  req.respond({ body: "Hello deno" })
}
*/
/*
const listener = Deno.listen({ port: 8080 });
for await (const conn of listener) {
  for await (const {request: req, respondWith: res} of Deno.serveHttp(conn)) {
    res(new Response("Hello deno"));
  }
}
*/
const port = Deno.args.length > 0 ? Number(Deno.args[0]) : 8080;
serve((req: Request) => new Response('Hello deno'), { port: port });
