# <span id="top">Playing with Deno on Windows</span>
<!--
Deno is is a simple, modern and secure runtime for JavaScript and TypeScript that uses the V8 JavaScript engine and is built in Rust.
-->
<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="./docs/images/deno.svg" width="100" alt="Deno project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://deno.land/" rel="external">Deno</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a> for experimenting with <a href="https://deno.land/" rel="external">Deno</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX][wix_examples] are other trending topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** plaform:

- [Deno 1.25][deno_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][deno_relnotes])
- [Git 2.37][git_downloads] ([*release notes*][git_relnotes])

Optionally one may also install the following software:

- [Nmap 7.92][nmap_downloads] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*change log*][nmap_changelog])
- [Node.js 14.x LTS][nodejs14_downloads] ([*change log*][nodejs14_changelog])

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (September 2022) <sup id="anchor_03">[3](#footnote_03)</sup>:

<pre style="font-size:80%;">
<a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values" rel="external">%USERPROFILE%</a>\.deno\           <i>(&lt; 1 MB)</i>
C:\opt\deno-1.25.2\            <i>( 60 MB)</i>
C:\opt\Git-2.37.3\             <i>(289 MB)</i>
C:\opt\nmap-7.92\              <i>( 41 MB)</i>
C:\opt\node-v14.20.0-win-x64\  <i>( 76 MB)</i>
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

## <span id="commands">Batch commands</span>[**&#x25B4;**](#top)

### **`setenv.bat`**

Command [**`setenv`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`deno.cmd`**][deno_cli], [**`node.exe`**][node_cli], [**`rustc.exe`**][rustc_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   deno 1.25.2, deployctl 0.4.0, ncat 7.92, rustc 1.62.0,
   git 2.37.3.windows.1, diff 3.8
Tool paths:
   C:\opt\deno-1.25.2\deno.exe
   <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\.deno\bin\deployctl.cmd
   C:\opt\nmap-7.92\ncat.exe
   %USERPROFILE%\.cargo\bin\rustc.exe
   C:\opt\Git-2.37.3\bin\git.exe
   C:\opt\Git-2.37.3\usr\bin\diff.exe
Environment variables:
   "CARGO_HOME=%USERPROFILE%\.cargo"
   "DENO_HOME=C:\opt\deno-1.25.2"
   "GIT_HOME=C:\opt\Git-2.37.3"
   "NMAP_HOME=C:\opt\nmap-7.92"
   "NODE_HOME=C:\opt\node-v14.20.0-win-x64"

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> deno</b>
C:\opt\deno-1.25.2\deno.exe
</pre>

> **:mag_right:** Subcommand `help` prints the following help message :
>   <pre style="font-size:80%;">
>   <b>&gt; <a href="setenv.bat">setenv</a> help</b>
>   Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
>   &nbsp;
>     Options:
>       -bash       start Git bash shell instead of Windows command prompt
>       -debug      show commands executed by this script
>       -verbose    display environment settings
>   &nbsp;
>     Subcommands:
>       help        display this help message
>   </pre>

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Deno TypeScript*** [↩](#anchor_01)

<dl><dd>
Command <code><a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> --version</code> displays the supported version of <a href="https://www.typescriptlang.org/">TypeScript</a>, namely version <a href="https://devblogs.microsoft.com/typescript/announcing-typescript-4-7/" rel="external"><code>4.7</code></a> in our case:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://deno.land/manual/getting_started/command_line_interface">deno</a> --version</b>
deno 1.25.2 (release, x86_64-pc-windows-msvc)
<a href="https://v8.dev/">v8</a> 10.6.194.5
typescript <a href="https://devblogs.microsoft.com/typescript/announcing-typescript-4-7/" rel="external">4.7.4</a>
</pre>
</dd></dl>
<!-- deno 1.17.3: v8  9.7.106.15, typescript 4.5.2 -->
<!-- deno 1.18.0: v8  9.8.177.6,  typescript 4.5.2 -->
<!-- deno 1.18.2: v8  9.8.177.6,  typescript 4.5.2 -->
<!-- deno 1.19.0: v8  9.9.115.7,  typescript 4.5.2 -->
<!-- deno 1.19.2: v8  9.9.115.7,  typescript 4.5.2 -->
<!-- deno 1.19.3: v8  9.9.115.8,  typescript 4.5.2 -->
<!-- deno 1.20.1: v8 10.0.139.6,  typescript 4.6.2 -->
<!-- deno 1.20.3: v8 10.0.139.6,  typescript 4.6.2 -->
<!-- deno 1.20.4: v8 10.0.139.6,  typescript 4.6.2 -->
<!-- deno 1.20.5: v8 10.0.139.6,  typescript 4.6.2 -->
<!-- deno 1.21.2: v8 10.0.139.17, typescript 4.6.2 -->
<!-- deno 1.21.3: v8 10.0.139.17, typescript 4.6.2 -->
<!-- deno 1.22.0: v8 10.0.139.17, typescript 4.6.2 -->
<!-- deno 1.22.1: v8 10.3.174.6,  typescript 4.6.2 -->
<!-- deno 1.23.3: v8 10.4.132.8,  typescript 4.7.4 -->
<!-- deno 1.23.4: v8 10.4.132.8,  typescript 4.7.4 -->
<!-- deno 1.24.0: v8 10.4.132.8,  typescript 4.7.4 -->
<!-- deno 1.24.2: v8 10.4.132.20, typescript 4.7.4 -->
<!-- deno 1.24.3: v8 10.4.132.20, typescript 4.7.4 -->
<!-- deno 1.25.2: v8 10.6.194.5 , typescript 4.7.4 -->

<span id="footnote_02">[2]</span> ***Nmap tools*** [↩](#anchor_02)

<dl><dd>
We are mostly interested in the <a href="https://nmap.org/ncat/guide/" rel="external"><code>Ncat</code></a> tool for reading, writing, redirecting, and encrypting data across a network. <a href="https://nmap.org/ncat/guide/" rel="external"><code>Ncat</code></a> operates in one of two modes: in connect mode, <a href="https://nmap.org/ncat/guide/" rel="external"><code>Ncat</code></a> works as a client, in listen mode it is a server,
</dd></dl>

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/denoland/deno/releases">deno-x86_64-pc-windows-msvc.zip</a>   <i>(24 MB)</i>
<a href="https://nmap.org/download.html">nmap-7.92-win32.zip</a>               <i>(22 MB)</i>
<a href="https://nodejs.org/dist/latest-v14.x/">node-v14.20.0-win-x64.zip</a>         <i>(27 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.37.3-64-bit.7z.exe</a>  <i>(41 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples
[akka_examples]: https://github.com/michelou/akka-examples
[book_portela]: https://www.packtpub.com/product/deno-web-development/9781800205666
[cpp_examples]: https://github.com/michelou/cpp-examples
[deno_cli]: https://deno.land/manual/getting_started/command_line_interface
[deno_downloads]: https://github.com/denoland/deno/releases
[deno_land]: https://deno.land/
[deno_relnotes]: https://github.com/denoland/deno/releases/tag/v1.25.2
[flix_examples]: https://github.com/michelou/flix-examples
[git_cli]: https://git-scm.com/docs/git
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.37.3.txt
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
[node_cli]: https://nodejs.org/api/cli.html
[nodejs]: https://nodejs.org/en/
[nodejs14_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V14.md#14.20.0
[nodejs14_downloads]: https://nodejs.org/dist/latest-v14.x/
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[rust_examples]: https://github.com/michelou/rust-examples
[rustc_cli]: https://doc.rust-lang.org/rustc/command-line-arguments.html
[scala3_examples]: https://github.com/michelou/dotty-examples
[spark_examples]: https://github.com/michelou/spark-examples
[spring_examples]: https://github.com/michelou/spring-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[typescript_4_6]: https://devblogs.microsoft.com/typescript/announcing-typescript-4-6/
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
