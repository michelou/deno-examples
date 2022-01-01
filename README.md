# <span id="top">Playing with Deno on Windows</span>
<!--
Deno is is a simple, modern and secure runtime for JavaScript and TypeScript that uses the V8 JavaScript engine and is built in Rust.
-->
<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="./docs/deno.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://deno.land/" rel="external">Deno</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with <a href="https://deno.land/" rel="external">Deno</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

[Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX][wix_examples] are other trending topics we are continuously monitoring.
<!--
> &#9757; ***Motivation***<br/>
> Our interest in [Deno][deno_land] is mainly driven by our past work with [Node.js][nodejs] (full stack projects).
-->
## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** plaform:

- [Deno 1.17][deno_downloads] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*release notes*][deno_relnotes])
- [Git 2.34][git_downloads] ([*release notes*][git_relnotes])

Optionally one may also install the following software:

- [Nmap 7.92][nmap_downloads] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*change log*][nmap_changelog])
- [Node.js 14.x LTS][nodejs14_downloads] ([*change log*][nodejs14_changelog])

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (January 2022) <sup id="anchor_03"><a href="#footnote_03">3</a></sup>:

<pre style="font-size:80%;">
<a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\.deno\           <i>(&lt; 1 MB)</i>
C:\opt\deno-1.17.1\            <i>( 54 MB)</i>
C:\opt\Git-2.34.1\             <i>(279 MB)</i>
C:\opt\nmap-7.92\              <i>( 41 MB)</i>
C:\opt\node-v14.18.2-win-x64\  <i>( 75 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
<a href="docs/">docs\</a>
<a href="examples/">examples\</a>{<a href="examples/README.md">README.md</a>}
<a href="portela-examples/">portela-examples\</a>{<a href="portela-examples/README.md">README.md</a>, <a href="portela-examples/Chapter01/">Chapter01</a>}
README.md
<a href="QUICKREF.md">QUICKREF.md</a>
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="TYPESCRIPT.md">TYPESCRIPT.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`docs\`**](docs/) contains [Deno][deno_land] related papers/articles.
- directory [**`examples\`**](examples/) contains [Deno][deno_land] code examples grabbed from various websites.
- directory [**`portela-examples\`**](portela-examples/) contains [Deno][deno_land] code examples from Portela's book [*Deno Web Development*][book_portela].
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`QUICKREF.md`**](QUICKREF.md) is our [Deno][deno_land] quick reference.
- file [**`RESOURCES.md`**](RESOURCES.md) gathers [Deno][deno_land] related informations.
- file [**`TYPESCRIPT.md`**](TYPESCRIPT.md) gathers [TypeScript][microsoft_ts] related informations.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`O:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> O: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\deno-examples</b>
> </pre>


## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Deno TypeScript*** [↩](#anchor_01)

<dl><dd>
Command <code><a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> --version</code> displays the supported version of <a href="https://www.typescriptlang.org/">TypeScript</a>, namely version <a href="https://devblogs.microsoft.com/typescript/announcing-typescript-4-5/" rel="external"><code>4.5.2</code></a> in our case:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> --version</b>
deno 1.17.1 (release, x86_64-pc-windows-msvc)
<a href="https://v8.dev/">v8</a> 9.7.106.15
typescript 4.5.2
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Nmap tools*** [↩](#anchor_02)

<dl><dd>
We are mostly interested in the <a href="https://nmap.org/ncat/guide/"><code>Ncat</code></a> tool for reading, writing, redirecting, and encrypting data across a network. <a href="https://nmap.org/ncat/guide/"><code>Ncat</code></a> operates in one of two modes: in connect mode, <a href="https://nmap.org/ncat/guide/"><code>Ncat</code></a> works as a client, in listen mode it is a server,
</dd></dl>

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/denoland/deno/releases">deno-x86_64-pc-windows-msvc.zip</a>   <i>(24 MB)</i>
<a href="https://nmap.org/download.html">nmap-7.92-win32.zip</a>               <i>(22 MB)</i>
<a href="https://nodejs.org/dist/latest-v14.x/">node-v14.18.2-win-x64.zip</a>         <i>(27 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.34.1-64-bit.7z.exe</a>  <i>(41 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[book_portela]: https://www.packtpub.com/product/deno-web-development/9781800205666
[deno_downloads]: https://github.com/denoland/deno/releases
[deno_land]: https://deno.land/
[deno_relnotes]: https://github.com/denoland/deno/releases/tag/v1.17.1
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.34.1.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[haskell_examples]: https://github.com/michelou/haskell-examples
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[microsoft_ts]: https://devblogs.microsoft.com/typescript/
[nmap_changelog]: https://nmap.org/changelog
[nmap_downloads]: https://nmap.org/download.html
[nodejs]: https://nodejs.org/en/
[nodejs14_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V14.md#14.17.5
[nodejs14_downloads]: https://nodejs.org/dist/latest-v14.x/
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[rust_examples]: https://github.com/michelou/rust-examples
[scala3_examples]: https://github.com/michelou/dotty-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
