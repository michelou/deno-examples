# <span id="top">Deno Examples</span> <span style="size:25%;"><a href="../README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="https://deno.land/logo.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>examples\</code></strong> contains <a href="https://deno.land/" rel="external">Deno</a> code examples coming from various websites - mostly from the <a href="https://deno.land/" rel="external">Deno project</a> - or written by ourself.
  </td>
  </tr>
</table>

> **:mag_right:** The Deno Standard Library <sup id="anchor_01"><a href="#footnote_01">1</a></sup> includes [Deno examples](https://deno.land/std/examples) which the user can execute directly from the command prompt, e.g.
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> run https://demo.land/std/examples/welcome.ts</b>
> Check https://deno.land/std/examples/welcome.ts
> Welcome to Deno!
> </pre>

## <span id="basic">Basic `eval` Examples</span>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> eval "console.log(Deno.version)"</b>
{ deno: "1.17.1", v8: "9.7.106.15", typescript: "4.5.2" }
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> eval "console.log(Deno.build)"</b>
{
  target: "x86_64-pc-windows-msvc",
  arch: "x86_64",
  os: "windows",
  vendor: "pc",
  env: "msvc"
}
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> eval "console.log(Deno.env.get('DENO_HOME'))"</b>
C:\opt\deno-1.17.1
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> eval "const p=Deno.run({ cmd: ['ls', '.'] });await p.status();p.close();"</b>
QUICKREF.md  RESOURCES.md   docs        eval.ts   portela-examples  setenv.bat
README.md    TYPESCRIPT.md  docs_LOCAL  examples  react-examples    setenv.sh
</pre>

> **:mag_right:** Option `--allow-run` is required when executing the same program from a TypeScript source file, e.g. `eval.ts` (see section [Creating a subprocess](https://deno.land/manual/examples/subprocess) of the online [Deno Manual](https://deno.land/manual)).
> 
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> eval.ts</b>
> const p = Deno.run({ cmd: ['ls', '.'] })
> await p.status()
> p.close()
> &nbsp;
> <b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> run --allow-run eval.ts</b>
> Check file:///O:/eval.ts
> QUICKREF.md  RESOURCES.md   docs        eval.ts   portela-examples  setenv.bat
> README.md    TYPESCRIPT.md  docs_LOCAL  examples  react-examples    setenv.sh
> </pre>


## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> **`std`** [↩](#anchor_01)

<dl><dd>
<a href="https://deno.land/manual/contributing/style_guide#codestdcode"><code>https://deno.land/std/</code></a> provides the baseline functionality that all Deno programs can rely on.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
