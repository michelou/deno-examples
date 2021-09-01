// page 34
import { serve } from "./deps.ts"

for await (const req of serve(":8080")) {
  req.respond({ body: "Hello deno" })
}
