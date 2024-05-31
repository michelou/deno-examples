# <span id="top">Book <i>Deno Web Development</i></span> <span style="size:25%;"><a href="../README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="https://deno.land/logo.svg" width="100" alt="Deno project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <code>portela-examples\</code> contains <a href="https://www.typescriptlang.org/" rel="external">TypeScript</a> examples presented in Portela's book <a href="https://www.packtpub.com/product/deno-web-development/9781800205666"><i>Deno Web Development</i></a> (<a href="https://www.packtpub.com/" rel="external">Packt</a>, 2021).
  </td>
  </tr>
</table>

## <span id="chapter01">Chapter 1</span>

### <span id="http-server">`http-server` Example</span>

Example [`http-server.ts`](./Chapter01/http-server/http-server.ts) makes use of the function `serve` from the remote [`http`](https://deno.land/std@0.201.0/http) library. The import clauses looks as follows:

<div class="hightlight highlight-source-js">
<pre style="font-size:80%;">
<span style="color:green;">// file: http-server.ts</span>
<b>import</b> { <a href="https://deno.land/std@0.208.0/http/server.ts?s=serve" rel="external">serve</a> } <b>from</b> <span style="color:darkred;">"https://deno.land/std@0.208.0/http/server.ts"</span>
&nbsp;
<b>for await</b> (<b>const</b> req of <a href="https://deno.land/std@0.208.0/http/server.ts?s=serve" rel="external">serve</a>(<span style="color:darkred;">":8080"</span>)) {
  req.respond({ body: <span style="color:darkred;">"Hello deno"</span> })
}
</pre>
</div>

We can run `http-server` either from the Windows prompt or from a Unix shell:

- We run the batch file [`http-server.bat`](./Chapter01/http-server/http-server.bat) from the Windows prompt. Note that the server process is started only once (it must be stopped manually) when we run the batch file several times:

  <pre style="font-size:80%;">
  <b>&gt; <a href="./Chapter01/http-server/http-server.bat">http-server.bat</a></b>
  [INFO] Start process listening on port 8080
  [INFO] Respond to the cURL request on port 8080
  Hello deno
  &nbsp;
  <b>&gt; <a href="./Chapter01/http-server/http-server.bat">http-server.bat</a></b>
  [INFO] Respond to the cURL request on port 8080
  Hello deno
  </pre>

- We run the shell script [`http-server.sh`](./Chapter01/http-server/http-server.sh) from a Unix shell ([Cygwin](https://www.cygwin.com/), [MinGW](https://www.mingw-w64.org/) or Unix).

  <pre style="font-size:80%;">
  <b>&gt; <a href="./Chapter01/http-server/http-server.sh">./http-server.sh</a></b>
  [INFO] Start process listening on port 8080
  [INFO] Respond to the cURL request on port 8080
  Hello deno
  &nbsp;
  <b>&gt; <a href="./Chapter01/http-server/http-server.sh">./http-server.sh</a></b>
  [INFO] Respond to the cURL request on port 8080
  Hello deno
  </pre>

### <span id="http-server-deps">`http-server-deps` Example</span> [**&#x25B4;**](#top)

In this first variant of the above example we split the code into two files:

- we add the file [`deps.ts`](./Chapter01/http-server-deps/deps.ts) which contains the original import clause(s)
   <pre style="font-size:80%;">
   <span style="color:green;">// file: deps.ts</span>
   <b>import</b> { serve } <b>from</b> "https://deno.land/std@0.190.0/http/server.ts"</pre>

- we modify the file [`https-server.ts`](./Chapter01/http-server-deps/http-server.ts) which now refers to [`deps.ts`](./Chapter01/http-server-deps/deps.ts) in the import clause (thus hiding the details of the remote [`std/http`](https://deno.land/std@0.201.0/http) library):
   <pre style="font-size:80%;">
   <span style="color:green;">// file: http-server.ts</span>
   <b>import</b> { serve } <b>from</b> <span style="color:darkred;">"./deps.ts"</span>
   &nbsp;
   <b>for await</b> (<b>const</b> req of serve(<span style="color:darkred;">":8080"</span>)) {
     req.respond({ body: <span style="color:darkred;">"Hello deno"</span> })
   }</pre>

### <span id="">`http-server-import-maps` Example</span>

Example `http-server-import-maps` is the second variant of the original example presented earlier. Besides the two files [`http-server.ts`](./Chapter01/http-server-import-maps/http-server.ts) and [`http-server.bat`](./Chapter01/http-server-import-maps/http-server.bat) we also :

- add the file [`import_map.json`](./Chapter01/http-server-lock-import/import_map.json)
   <div class="hightlight highlight-source-js">
   <pre style="font-size:80%;">
   {
     "imports": {
       "http/": "https://deno.land/std@0.197.0/http/"
     }
   }</pre>
   </div>

- and update the file [`deps.ts`](http-server-lock-import/deps.ts) with a *user-defined name* for the `http` library.
   <div class="hightlight highlight-source-js">
   <pre style="font-size:80%;">
   <span style="color:green;">// file: deps.ts</span>
   <b>export</b> { serve } <b>from</b> <span style="color:darkred;">"http/server.ts"</span></pre>
   </div>

### <span id="fetch-deno-logo">`fetch-deno-logo` Example</span> [**&#x25B4;**](#top)

Example [`fetch-deno-logo`](./Chapter01/fetch-deno-logo/fetch-deno-logo.ts) download a SVG image (e.g. the Deno logo) from the Internet and prints the HTML code with the embedded image.

<pre style="font-size:80%;">
<b>&gt; <a href="./Chapter01/fetch-deno-logo/fetch-deno-logo.bat">fetch-deno-logo.bat</a></b>
&lt;html&gt;
&lt;img src="data:image/svg+xml;base64,PHN2ZwogIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICB3aWR0aD0iNTEyIgogIGhlaWdodD0iNTEyIgogIHZpZXdCb3g9IjAgMCA1MTIgNTEyIgo+CiAgPHRpdGxlPkRlbm8gbG9nbzwvdGl0bGU+CiAgPG1hc2sgaWQ9ImEiPgogICAgPGNpcmNsZSBmaWxsPSJ3aGl0ZSIgY3g9IjI1NiIgY3k9IjI1NiIgcj0iMjMwIiAvPgogIDwvbWFzaz4KICA8Y2lyY2xlIGN4PSIyNTYiIGN5PSIyNTYiIHI9IjI1NiIgLz4KICA8cGF0aAogICAgbWFzaz0idXJsKCNhKSIKICAgIHN0cm9rZT0id2hpdGUiCiAgICBzdHJva2Utd2lkdGg9IjI1IgogICAgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIgogICAgZD0iTTcxIDMxOWwxNy02M00xMDcuOTY0IDE2MS4wOTVsMTctNjNNMzYuOTMgMjIxbDE3LTYzTTEyNS45NjQgMzg1bDE3LTYzTTE2MC4zNzIgNDg2LjgyOWwxNy02M00yMzAgNDU2LjMyOWwxNy02M00yMDYuMjU3IDkyLjU4N2wxNy02M00zMjYuMzk1IDE3My4wMDRsMTctNjNNNDUyLjE4MiAzMDQuNjkzbDE3LTYzTTQwOS4xMjQgMjIxbDE3LTYzTTI5OS4wMjcgNTQuNTU4bDE3LTYzTTQwMC42MjQgODYuMDU4bDE3LTYzIgogIC8+CiAgPHBhdGgKICAgIG1hc2s9InVybCgjYSkiCiAgICBmaWxsPSJ3aGl0ZSIKICAgIHN0cm9rZT0iYmxhY2siCiAgICBzdHJva2Utd2lkdGg9IjEyIgogICAgZD0iTTI1Mi4yMjUgMzQ0LjQxOGMtODYuNjUgMi42MS0xNDQuNTc2LTM0LjUtMTQ0LjU3Ni05NC4zNjMgMC02MS40OTQgNjAuMzMtMTExLjE0NSAxMzguMzUxLTExMS4xNDUgMzcuNjgzIDAgNjkuNTMyIDEwLjY1IDk0LjM5MiAzMC4wOTIgMjEuODgyIDE3LjExMyAzNy41MjEgNDAuNTI2IDQ1LjUxOSA2Ni4zMTIgMi41NzQgOC4zMDEgMjIuODYzIDgzLjc2NyA2MS4xMTIgMjI3LjI5NWwxLjI5NSA0Ljg2LTE1OS43OTMgNzQuNDQzLTEuMTAxLTguMDYzYy04Ljg1LTY0Ljc3OC0xNi41NDYtMTEzLjMzOC0yMy4wNzYtMTQ1LjYzNC0zLjIzNy0xNi4wMDQtNi4xNzgtMjcuOTYtOC43OS0zNS43OTQtMS4yMjctMy42ODItMi4zNTUtNi4zNjEtMy4zMDMtNy45NTJhMTIuNTYgMTIuNTYgMCAwMC0uMDMtLjA1eiIKICAvPgogIDxjaXJjbGUgbWFzaz0idXJsKCNhKSIgY3g9IjI2MiIgY3k9IjIwMyIgcj0iMTYiIC8+Cjwvc3ZnPg==" /&gt;
&lt;/html&gt;
</pre>

## <span id="chapter02">Chapter 2</span>[**&#x25B4;**](#top)

<i>wip</i>


## <span id="chapter04">Chapter 4</span>

<i>wip</i>

## <span id="chapter05">Chapter 5</span>

<i>wip</i>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
