# <span id="top">Deno Quick Reference</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="./docs/deno.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://deno.land/" rel="external">Deno</a> hints and tips.
  </td>
  </tr>
</table>

Covered topics include: [Deno versus Node.js](#nodejs), [Deno subcommands](#subcommands), [Deno runtime](#runtime), [Windows specific fixes](#fixes).

## <span id="nodejs">Deno versus Node.js</span>
<!--
https://alanstorm.com/comparing-a-deno-and-node-js-hello-world-program/
-->
1. CommonJS versus ECMAScript modules

   <a href="https://deno.land/">Deno</a> supports <i>only</i> the ECMAScript modules (short <i>ES modules</i> or <i>ESM</i>) while <a href="https://nodejs.org/">Node.js</a> supports both formats for the CommonJS and ECMAScript modules.

   <pre style="font-size:80%;">
   <b>const</b> http = require('http'); <span style="color:green;">/* CommonJS */</span>
   <b>import</b> { serve } <b>from</b> "https://deno.land/std/http/server.ts"; <span style="color:green;">/* ECMAScript */</span>
   </pre>

   > **:mag_right:** Deno supports the `@deno-types` compiler hint to specify a type definition file when type checking instead of the imported JavaScript file (see "[Providing types when importing](https://deno.land/manual@v1.9.2/typescript/types#providing-types-when-importing)").

2. Runtime versus Standard library

   Unlike Node.js <a href="https://deno.land/">Deno</a> has a lightweight built-in runtime of around 130 methods, functions and classes. See section [Deno Runtime](#runtime) for more details.

## <span id="subcommands">Deno Subcommands</span>

### **`deno cache`**

- `deno cache` makes sure we have a local copy of our code's dependencies without having to run it<br/><i>Note</i>: It makes think of command [`npm install`](https://docs.npmjs.com/cli/v7/commands/npm-install) on Node.js.
- With the `--reload` flag `deno cache` forces the dependencies to
be downloaded. A comma-separated list of modules that must be reloaded can be sent as
a parameter to the `--reload` flag.

### **`deno doc`**

The following command displays the documentation for method `serve` of the standard library's HTTP module.

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc https://deno.land/std@0.106.0/http/<a href="https://deno.land/std@0.106.0/http/server.ts">server.ts</a> serve</b>
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

## <span id="runtime">Deno Runtime</span>

<!-- Deno Web Development, p.59 -->
Two types of functions are available on Deno without any imports: [Web APIs](https://developer.mozilla.org/en-US/docs/Web/API) and the Deno built-in API. Code written using Web APIs can be bundled and run in the browser with no transformations.

1. `WebAssembly` namespace

   Interfaces in the `WebAssembly` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin WebAssembly |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]interface"</b>
   interface GlobalDescriptor
   interface MemoryDescriptor
   interface ModuleExportDescriptor
   interface ModuleImportDescriptor
   interface TableDescriptor
   interface WebAssemblyInstantiatedSource
   </pre>

   Functions in the `WebAsssembly` namepspace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin WebAssembly |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]function"</b>
   function compile(bytes: BufferSource): Promise<Module>
   function compileStreaming(source: Response | Promise<Response>): Promise<Module>
   function instantiate(bytes: BufferSource, importObject?: Imports): Promise<WebAssemblyInstantiatedSource>
   function instantiate(moduleObject: Module, importObject?: Imports): Promise<Instance>
   function instantiateStreaming(response: Response | PromiseLike<Response>, importObject?: Imports): Promise<WebAssemblyInstantiatedSource>
   function validate(bytes: BufferSource): boolean
   </pre>
   > **:mag_right:** The above functions are defined in the [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly#static_methods).

2. `Deno` namespace

   Interfaces in the `Deno` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; set NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]interface"</b>
   interface <a href="https://doc.deno.land/builtin/stable#Deno.MemoryUsage">MemoryUsage</a>
   interface TestDefinition
   interface Reader
   interface ReaderSync
   interface Writer
   interface WriterSync
   interface Closer
   interface Seeker
   interface SeekerSync
   interface OpenOptions
   interface ReadFileOptions
   interface MkdirOptions
   interface MakeTempOptions
   interface RemoveOptions
   interface FileInfo
   interface DirEntry
   interface WriteFileOptions
   interface <a href="https://doc.deno.land/builtin/stable#Deno.Metrics">Metrics</a>
   interface FsEvent
   interface FsWatcher extends AsyncIterable<FsEvent>
   interface RunOptions
   [...]
   </pre>

   `read` functions in the `Deno` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]function read"</b>
   function readSync(rid: number, buffer: Uint8Array): number | null
   function read(rid: number, buffer: Uint8Array): Promise<number | null>
   function readAll(r: Reader): Promise<Uint8Array>
   function readAllSync(r: ReaderSync): Uint8Array
   function readTextFileSync(path: string | URL): string
   function <a href="https://doc.deno.land/builtin/stable#Deno.readTextFile">readTextFile</a>(path: string | URL, options?: ReadFileOptions): Promise<string>
   function readFileSync(path: string | URL): Uint8Array
   function readFile(path: string | URL, options?: ReadFileOptions): Promise<Uint8Array>
   function readDirSync(path: string | URL): Iterable<DirEntry>
   function readDir(path: string | URL): AsyncIterable<DirEntry>
   function readLinkSync(path: string | URL): string
   function <a href="https://doc.deno.land/builtin/stable#Deno.readLink">readLink</a>(path: string | URL): Promise<string>
   </pre>
   > [**:mag_right:**] We can evaluate the code example presented in the [`readTextFile`](https://doc.deno.land/builtin/stable#Deno.readTextFile) documentation: 
   > <pre style="font-size:80%;">
   > <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin <a href="https://doc.deno.land/builtin/stable#Deno.readTextFile">Deno.readTextFile</a></b>
   > Defined in lib.deno.d.ts:1430:2
   >&nbsp;
   > function readFile(path: string | URL, options?: ReadFileOptions):  Promise<Uint8Array>
   >   Reads and resolves to the entire contents of a file as an array of bytes.
   >   `TextDecoder` can be used to transform the bytes to string if required.
   >   Reading a directory returns an empty data array.
   >&nbsp;
   >   ```ts
   >   const data = await Deno.readTextFile("hello.txt");
   >   console.log(data);
   >    ```
   >&nbsp;
   >   Requires `allow-read` permission.
   > </pre>
   > For instance:
   > <pre style="font-size:80%;">
   > <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> eval "const data = await Deno.readTextFile('.gitignore'); console.log(data);"</b>
   > .idea/
   > .project
   > .settings/
   > .vscode/
   > *_LOCAL/
   > out/
   > target/
   > </pre>

## <span id="win_fixes">Windows specific fixes</span>

### [**1.14.2**](https://github.com/denoland/deno/releases/tag/v1.14.2) (2021.09.28)

- fix: subprocess kill support on windows ([#12134](https://github.com/denoland/deno/pull/12134)).

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[deno_land]: https://deno.land/
