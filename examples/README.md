# <span id="top">Deno Examples</span> <span style="font-size:90%;">[↩](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="https://deno.land/logo.svg" width="100" alt="Deno project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>examples\</code></strong> contains <a href="https://deno.land/" rel="external">Deno</a> code examples coming from various websites - mostly from the <a href="https://deno.land/" rel="external">Deno project</a> - or written by ourself.
  </td>
  </tr>
</table>

> **:mag_right:** The Deno Standard Library <sup id="anchor_01"><a href="#footnote_01">1</a></sup> includes [Deno examples](https://deno.land/std/examples) which the user can execute directly from the command prompt, e.g.
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> run https://deno.land/std/examples/welcome.ts</b>
> Check https://deno.land/std/examples/welcome.ts
> Welcome to Deno!
> </pre>

## <span id="basic">Basic Examples with `eval`</span> [**&#x25B4;**](#top)

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> eval "console.log(Deno.version)"</b>
{ deno: "1.45.4", v8: "12.7.224.13", typescript: "5.5.2" }
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> eval "console.log(Deno.build)"</b>
{
  target: "x86_64-pc-windows-msvc",
  arch: "x86_64",
  os: "windows",
  vendor: "pc",
  env: "msvc"
}
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> eval "console.log(Deno.env.get('DENO_HOME'))"</b>
C:\opt\deno
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> eval "const p=Deno.run({ cmd: ['ls', '.'] });await p.status();p.close();"</b>
QUICKREF.md  RESOURCES.md   docs        eval.ts   portela-examples  setenv.bat
README.md    TYPESCRIPT.md  docs_LOCAL  examples  react-examples    setenv.sh
</pre>

> **:mag_right:** Option `--allow-run` is required when executing the same program from a TypeScript source file, e.g. `eval.ts` (see section [Creating a subprocess](https://deno.land/manual/examples/subprocess) of the online [Deno Manual](https://deno.land/manual)).
> 
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> eval.ts</b>
> const p = Deno.run({ cmd: ['ls', '.'] })
> await p.status()
> p.close()
> &nbsp;
> <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> run --allow-run eval.ts</b>
> Check file:///O:/eval.ts
> QUICKREF.md  RESOURCES.md   docs        eval.ts   portela-examples  setenv.bat
> README.md    TYPESCRIPT.md  docs_LOCAL  examples  react-examples    setenv.sh
> </pre>

## <span id="cat">`cat` Example</span> [**&#x25B4;**](#top)

We present three variations of the `cat` example :
- Firstly [`cat.bat`](cat/cat.bat) runs the *remote* script file [`cat.ts`](https://deno.land/std@0.120.0/examples/cat.ts) from the `std` library.
- Secondly [`cat.bat`](cat_2/cat.bat) runs the same script file [`cat.ts`](cat_2/cat.ts) *locally*.
- Finally, [`cat.bat`](cat_3/cat.bat) runs the modified local script file [`cat.ts`](cat_3/cat.ts) with its dependencies defined in the separate file [`import_map.json`](cat_3/import_map.json). 

<pre style="font-size:80%;">
<b>&gt; <a href="cat_3/cat.bat">cat.bat</a></b>
&nbsp;
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface" rel="external">deno</a> run --allow-read "--importmap=O:\examples\cat_3\import_map.json" "O:\examples\cat_3\cat.ts" "O:\examples\cat_3\cat.bat"</b>
Check file:///O:/examples/cat_3/cat.ts
@set _BASENAME=%~n0
@set "_ROOT_DIR=%~dp0"

@set "_IMPORT_FILE=%_ROOT_DIR%import_map.json"
@set "_SCRIPT_FILE=%_ROOT_DIR%%_BASENAME%.ts"
@set _SCRIPT_ARGS="%_ROOT_DIR%%_BASENAME%.bat"

@set _RUN_OPTS=--allow-read "--importmap=%_IMPORT_FILE%"

deno run %_RUN_OPTS% "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
</pre>

## <span id="file_search">`file_search` Example</span> [**&#x25B4;**](#top)

Command [**`file_search.bat`**](./file_search/file_search.bat) with no option launches the script [`file_search.ts`](./file_search/file_search.ts) which displays the options :

<pre style="font-size:80%;">
<b>&gt; <a href="./file_search/file_search.bat">file_search.bat</a></b>

O:\examples\file_search>deno run --allow-read "O:\examples\file_search\file_search.ts"
Options:
  --help       Show help                                               [boolean]
  --version    Show version number                                     [boolean]
  --text       the text to search for within the current directory    [required]
  --extension  a file extension to match against
  --replace    the text to replace any matches with

Missing required argument: text
</pre>

Command [**`file_search.bat`**](./file_search/file_search.bat) with option `--text await` launches the script [`file_search.ts`](./file_search/file_search.ts) which searches for text `await` within the current directory:

<pre style="font-size:80%;">
<b>&gt; <a href="./file_search/file_search.bat">file_search.bat</a> --text await</b>

O:\examples\file_search>deno run --allow-read "O:\examples\file_search\file_search.ts" --text await
O:\examples\file_search\file_search.ts
=> 35 for await (const fileOrFolder of Deno.readDir(directory)) {
=> 42 const nestedFiles = await getFilesList(
=> 62 const files = await getFilesList(Deno.cwd(), {
=> 74 const contents = await Deno.readTextFile(file);
=> 93 await Deno.writeTextFile(file, newContents);
</pre>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **`std`** [↩](#anchor_01)

<dl><dd>
<a href="https://deno.land/std/" rel="external"><code>https://deno.land/std/</code></a> provides the baseline functionality that all Deno programs can rely on.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
