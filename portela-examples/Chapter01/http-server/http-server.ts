import { serve } from "https://deno.land/std@0.106.0/http/server.ts"

for await (const req of serve(":8080")) {
  req.respond({ body: "Hello deno" })
}
