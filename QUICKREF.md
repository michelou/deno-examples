# <span id="top">Deno Quick Reference</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="./docs/deno.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://deno.land/" rel="external">Deno</a> hints and tips.
  </td>
  </tr>
</table>

## Deno versus Node.js
<!--
https://alanstorm.com/comparing-a-deno-and-node-js-hello-world-program/
-->
1. CommonJS vs. ECMAScript modules

<p style="margin:0 0 0 40px;">
<a href="https://deno.land/">Deno</a> supports <i>only</i> the ECMAScript modules while <a href="https://nodejs.org/">Node.js</a> supports both formats for the CommonJS and ECMAScript modules.
</p>
<pre style="margin:0 0 8px 40px;font-size:80%;">
<b>const</b> http = require('http'); <span style="color:green;">/* CommonJS */</span>
<b>import</b> { serve } <b>from</b> "https://deno.land/std/http/server.ts"; <span style="color:green;">/* ECMAScript */</span>
</pre>

2. Runtime vs. Standard library

<p style="margin:0 0 0 40px;">Unlike Node.js <a href="https://deno.land/">Deno</a> has a lightweight built-in runtime of around 130 methods, functions and classes.
</p>

## <span id="subcommands">Deno Subcommands</span>

### **`deno cache`**

- `deno cache` makes sure we have a local copy of our code's dependencies without having to run it<br/><i>Note</i>: It makes think of command [`npm install`](https://docs.npmjs.com/cli/v7/commands/npm-install) on Node.js.
- With the `--reload` flag `deno cache` forces the dependencies to
be downloaded. A comma-separated list of modules that must be reloaded can be sent as
a parameter to the `--reload` flag.

### **`deno doc`**

The following command displays the documentation for method `serve` of the standard library's HTTP module.

<pre style="font-size:80%;">
<b> &gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc https://deno.land/std@0.106.0/http/<a href="https://deno.land/std@0.106.0/http/server.ts">server.ts</a> serve</b>
Defined in https://deno.land/std@0.106.0/http/server.ts:299:0

function serve(addr: string | HTTPOptions): Server
  Create a HTTP server

      import { serve } from "https://deno.land/std/http/server.ts";
      const body = "Hello World\n";
      const server = serve({ port: 8000 });
      for await (const req of server) {
        req.respond({ body });
      }
</pre>

The following command displays the documentation for method `writeFile` of the Deno built-in API:

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno.writeFile</b>
Defined in lib.deno.d.ts:1724:2

function writeFile(path: string | URL, data: Uint8Array, options?: WriteFileOptions): Promise<void>
  Write `data` to the given `path`, by default creating a new file if needed,
  else overwriting.

  ```ts
  const encoder = new TextEncoder();
  const data = encoder.encode("Hello world\n");
  await Deno.writeFile("hello1.txt", data);  // overwrite "hello1.txt" or create it
  await Deno.writeFile("hello2.txt", data, {create: false});  // only works if "hello2.txt" exists
  await Deno.writeFile("hello3.txt", data, {mode: 0o777});  // set permissions on new file
  await Deno.writeFile("hello4.txt", data, {append: true});  // add data to the end of the file
  ```

  Requires `allow-write` permission, and `allow-read` if `options.create` is `false`.
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[deno_land]: https://deno.land/
