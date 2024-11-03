# <span id="top">Deno Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="./docs/images/deno.svg" width="100" alt="Deno project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://deno.land/" rel="external">Deno</a> hints and tips.</td>
  </tr>
</table>

Covered topics include: [Deno versus Node.js](#nodejs), [Deno commands](#commands), [Deno runtime](#runtime), [Windows specific fixes](#fixes).

## <span id="nodejs">Deno versus Node.js</span>
<!--
https://alanstorm.com/comparing-a-deno-and-node-js-hello-world-program/
-->
1. CommonJS versus ECMAScript modules

   <a href="https://deno.land/manual/node#interoperating-with-node-and-npm" rel="external">Deno</a> supports <i>only</i> the ECMAScript modules (short <i>ES modules</i> or <i>ESM</i>) while <a href="https://nodejs.org/" rel="external">Node.js</a> supports both formats for the CommonJS and ECMAScript modules.

   <pre style="font-size:80%;">
   <b>const</b> http = require('http'); <span style="color:green;">/* CommonJS */</span>
   <b>import</b> { serve } <b>from</b> "https://deno.land/std/http/<a href="https://deno.land/std/http/server.ts" rel="external">server.ts</a>"; <span style="color:green;">/* ECMAScript */</span>
   </pre>

   > **:mag_right:** Deno supports the `@deno-types` compiler hint to specify a type definition file when type checking instead of the imported JavaScript file (see "[Providing types when importing](https://deno.land/manual@v1.21.0/typescript/types#providing-types-when-importing)").

2. Runtime versus Standard library

   Unlike Node.js <a href="https://deno.land/">Deno</a> has a lightweight built-in runtime of around 130 methods, functions and classes. See section [Deno Runtime](#runtime) for more details.

## <span id="commands">Deno Commands</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

### **`deno cache`**

- `deno cache` makes sure we have a local copy of our code's dependencies without having to run it<br/><i>Note</i>: It makes think of command [`npm install`](https://docs.npmjs.com/cli/v7/commands/npm-install) on Node.js.
- With the `--reload` flag `deno cache` forces the dependencies to
be downloaded. A comma-separated list of modules that must be reloaded can be sent as
a parameter to the `--reload` flag.

### **`deno doc`**

The following command displays the documentation for method `serve` of the standard library's HTTP module.

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc https://deno.land/std@0.208.0/http/<a href="https://deno.land/std@0.208.0/http/server.ts">server.ts</a> serve</b>
Defined in https://deno.land/std@0.208.0/http/server.ts:572:0

<b>function</b> serve(addr: string | HTTPOptions): Server
  Serves HTTP requests with the given handler.

  You can specify an object with a port and hostname option, which is the address to listen on.
  The default is port 8000 on hostname "0.0.0.0".

  The below example serves with the port 8000.
  [...]
</pre>

The following command displays the documentation for method `writeFile` of the Deno built-in API:

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno.writeFile</b>
Defined in lib.deno.d.ts:2048:2

<b>function</b> writeFile(path: string | URL, data: Uint8Array, options?: WriteFileOptions): Promise<void>
  Write `data` to the given `path`, by default creating a new file if needed,
  else overwriting.

  ```ts
  <b>const</b> encoder = new TextEncoder();
  const data = encoder.encode("Hello world\n");
  await Deno.writeFile("hello1.txt", data);  // overwrite "hello1.txt" or create it
  await Deno.writeFile("hello2.txt", data, {create: false});  // only works if "hello2.txt" exists
  await Deno.writeFile("hello3.txt", data, {mode: 0o777});  // set permissions on new file
  await Deno.writeFile("hello4.txt", data, {append: true});  // add data to the end of the file
  ```

  Requires `allow-write` permission, and `allow-read` if `options.create` is `false`.
</pre>

## <span id="runtime">Deno Runtime</span> [**&#x25B4;**](#top)

<!-- Deno Web Development, p.59 -->
Two types of functions are available on [Deno][deno_land] without any imports: [Web APIs](https://developer.mozilla.org/en-US/docs/Web/API) and the Deno built-in API. Code written using Web APIs can be bundled and run in the browser with no transformations.

1. `WebAssembly` namespace

   Interfaces in the `WebAssembly` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin WebAssembly |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /r /c:"^[ ][ ]interface"</b>
   interface <a href="https://deno.land/api?s=WebAssembly.GlobalDescriptor" rel="external">GlobalDescriptor</a>
   interface <a href="https://deno.land/api?s=WebAssembly.MemoryDescriptor" rel="external">MemoryDescriptor</a>
   interface <a href="https://deno.land/api?s=WebAssembly.ModuleExportDescriptor" rel="external">ModuleExportDescriptor</a>
   interface <a href="https://deno.land/api?s=WebAssembly.ModuleImportDescriptor" rel="external">ModuleImportDescriptor</a>
   interface <a href="https://deno.land/api?s=WebAssembly.TableDescriptor" rel="external">TableDescriptor</a>
   interface <a href="https://deno.land/api?s=WebAssembly.WebAssemblyInstantiatedSource" rel="external">WebAssemblyInstantiatedSource</a>
   </pre>

   Functions in the `WebAsssembly` namepspace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin WebAssembly |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]function"</b>
   function <a href="https://deno.land/api?s=WebAssembly.compile" rel="external">compile</a>(bytes: BufferSource): Promise<Module>
   function compileStreaming(source: Response | Promise<Response>): Promise<Module>
   function <a href="https://deno.land/api?s=WebAssembly.instantiate" rel="external">instantiate</a>(bytes: BufferSource, importObject?: Imports): Promise<WebAssemblyInstantiatedSource>
   function instantiate(moduleObject: Module, importObject?: Imports): Promise<Instance>
   function instantiateStreaming(response: Response | PromiseLike<Response>, importObject?: Imports): Promise<WebAssemblyInstantiatedSource>
   function <a href="https://deno.land/api?s=WebAssembly.validate" rel="external">validate</a>(bytes: BufferSource): boolean
   </pre>
   > **:mag_right:** The above functions are defined in the [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly#static_methods).

2. `Deno` namespace

   Interfaces in the `Deno` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]interface"</b>
   interface <a href="https://deno.land/api?s=Deno.memoryUsage">MemoryUsage</a>
   interface <a href="https://deno.land/api?s=Deno.TestDefinition" rel="external">TestDefinition</a>
   interface <a href="https://deno.land/api?s=Deno.Reader" rel="external">Reader</a>
   interface <a href="https://deno.land/api?s=Deno.ReaderSync" rel="external">ReaderSync</a>
   interface <a href="https://deno.land/api?s=Deno.Writer" rel="external">Writer</a>
   interface <a href="https://deno.land/api?s=Deno.WriterSync">WriterSync</a>
   interface <a href="https://deno.land/api?s=Deno.Close">Closer</a>
   interface <a href="https://deno.land/api?s=Deno.Seeker">Seeker</a>
   interface <a href="https://deno.land/api?s=Deno.SeekerSync">SeekerSync</a>
   interface <a href="https://deno.land/api?s=Deno.OpenOptions">OpenOptions</a>
   interface <a href="https://deno.land/api?s=Deno.ReadFileOptions">ReadFileOptions</a>
   interface <a href="https://deno.land/api?s=Deno.MkdirOptions">MkdirOptions</a>
   interface <a href="https://deno.land/api?s=Deno.MakeTempOptions">MakeTempOptions</a>
   interface <a href="https://deno.land/api?s=Deno.RemoveOptions">RemoveOptions</a>
   interface <a href="https://deno.land/api?s=Deno.FileInfo">FileInfo</a>
   interface <a href="https://deno.land/api?s=Deno.DirEntry">DirEntry</a>
   interface <a href="https://deno.land/api?s=Deno.WriteFileOptions">WriteFileOptions</a>
   interface <a href="https://deno.land/api?s=Deno.Metrics" rel="external">Metrics</a>
   interface <a href="https://deno.land/api?s=Deno.FsEvent" rel="external">FsEvent</a>
   interface <a href="https://deno.land/api?s=Deno.FsWatcher" rel="external">FsWatcher</a> extends AsyncIterable<FsEvent>
   interface <a href="https://deno.land/api?s=Deno.RunOptions" rel="external">RunOptions</a>
   [...]
   </pre>

   `read` functions in the `Deno` namespace are:
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> NO_COLOR=true & <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> doc --builtin Deno |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /r /c:"^[ ][ ]function read"</b>
   function <a href="https://deno.land/api?s=Deno.readSync" rel="external">readSync</a>(rid: number, buffer: Uint8Array): number | null
   function <a href="https://deno.land/api?s=Deno.read" rel="external">read</a>(rid: number, buffer: Uint8Array): Promise&lt;number | null&gt;
   function <a href="https://deno.land/std/streams/read_all.ts?s=readAll">readAll</a>(r: Reader): Promise&lt;Uint8Array&gt;
   function readAllSync(r: ReaderSync): Uint8Array
   function <a href="https://deno.land/api?s=Deno.readTextFileSync">readTextFileSync</a>(path: string | URL): string
   function <a href="https://deno.land/api?s=Deno.readTextFile">readTextFile</a>(path: string | URL, options?: ReadFileOptions): Promise<string>
   function readFileSync(path: string | URL): Uint8Array
   function readFile(path: string | URL, options?: ReadFileOptions): Promise<Uint8Array>
   function <a href="https://deno.land/api?s=Deno.readDirSync">readDirSync</a>(path: string | URL): Iterable<DirEntry>
   function <a href="https://deno.land/api?s=Deno.readDir">readDir</a>(path: string | URL): AsyncIterable<DirEntry>
   function <a href="https://deno.land/api?s=Deno.readLinkSync">readLinkSync</a>(path: string | URL): string
   function <a href="https://deno.land/api?s=Deno.readLink">readLink</a>(path: string | URL): Promise<string>
   </pre>
   > **:mag_right:** We can evaluate the code example presented in the [`readTextFile`](https://doc.deno.land/builtin/stable#Deno.readTextFile) documentation: 
   > <pre style="font-size:80%;">
   > <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> doc --builtin <a href="https://doc.deno.land/builtin/stable#Deno.readTextFile">Deno.readTextFile</a></b>
   > Defined in lib.deno.d.ts:1725:2
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
   > <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> eval "const data = await Deno.readTextFile('.gitignore'); console.log(data);"</b>
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

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[deno_land]: https://deno.land/
