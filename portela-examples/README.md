# <span id="top">Book <i>Deno Web Development</i></span> <span style="size:25%;"><a href="../README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="https://deno.land/logo.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <code>portela-examples\</code> contains <a href="https://www.typescriptlang.org/" rel="external">TypeScript</a> examples presented in Portela's book <a href="https://www.packtpub.com/product/deno-web-development/9781800205666"><i>Deno Web Development</i></a> (<a href="https://www.packtpub.com/">Packt</a>, 2021).
  </td>
  </tr>
</table>

## <span id="chapter_01">Chapter 1</span>

### `http-server`

In example [`http-server.ts`](./http-server/http-server.ts) we make use of the function `serve` from the remote [`std/http`](https://deno.land/std@0.106.0/http) library. The import clauses looks as follows:

<pre style="font-size:80%;">
<span style="color:green;">// file: http-server.ts</span>
<b>import</b> { serve } <b>from</b> "https://deno.land/std@0.106.0/http/server.ts"
&nbsp;
<b>for await</b> (<b>const</b> req of serve(":8080")) {
  req.respond({ body: "Hello deno" })
}
</pre>

Below we run the batch file [`http-server.bat`](./http-server/http-server.bat) two times; not that the server process is started only once (and must be stopped manually) :

<pre style="font-size:80%;">
<b>&gt; <a href="./http-server/http-server.bat">http-server.bat</a></b>
[INFO] Start process listening on port 8080
[INFO] Respond to the cURL request on port 8080
Hello deno
&nbsp;
<b>&gt; <a href="./http-server/http-server.bat">http-server.bat</a></b>
[INFO] Respond to the cURL request on port 8080
Hello deno
</pre>

### `http-server-lock`

In this first variant of the above example we split the code into two files:

- we add the file [`deps.ts`](http-server-lock/deps.ts) which contains the original import clause(s)
   <pre style="font-size:80%;">
   <span style="color:green;">// file: deps.ts</span>
   <b>import</b> { serve } <b>from</b> "https://deno.land/std@0.106.0/http/server.ts"</pre>

- we modify the file [`https-server.ts`](http-server-lock/http-server.ts) which now refers to [`deps.ts`](http-server-lock/deps.ts) in the import clause (thus hiding the details of the remote [`std/http`](https://deno.land/std@0.106.0/http) library):
   <pre style="font-size:80%;">
   <span style="color:green;">// file: http-server.ts</span>
   <b>import</b> { serve } <b>from</b> "./deps.ts"
   &nbsp;
   <b>for await</b> (<b>const</b> req of serve(":8080")) {
     req.respond({ body: "Hello deno" })
   }</pre>

### `http-server-lock-import`

In the second variant of the original example we introduce another file:

- we add the file [`import_map.json`](http-server-lock-import/import_map.json)
   <pre style="font-size:80%;">
   {
     "imports": {
       "http/": "https://deno.land/std@0.106.0/http/"
     }
   }</pre>

- we update the file [`deps.ts`](http-server-lock-import/deps.ts) with a *user-defined name* for the `http` library.
   <pre style="font-size:80%;">
   <b>export</b> { serve } <b>from</b> "http/server.ts"</pre>

## <span id="chapter_02">Chapter 2</span>

<i>WIP</i>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
