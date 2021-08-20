# <span id="top">Playing with Deno on Windows</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://deno.land/" rel="external"><img style="border:0;" src="https://deno.land/logo.svg" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://deno.land/" rel="external">Deno</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with <a href="https://deno.land/" rel="external">Deno</a> on the <b>Microsoft Windows</b> platform..
  </td>
  </tr>
</table>

[GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Scala 3][scala3_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** plaform:

- [Deno 1.13][deno_downloads] ([*release notes*][deno_relnotes])
- [Git 2.33][git_downloads] ([*release notes*][git_relnotes])


> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (August 2021) <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup>:

<pre style="font-size:80%;">
C:\opt\deno-1.13.1\   <i>( 54.7 MB)</i>
C:\opt\Git-2.33.0\    <i>(279.0 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
examples\
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`examples\`**](examples/) contains [Deno][deno_land] code examples grabbed from various websites.
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) gathers [Deno][deno_land] related informations.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`O:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> O: %USERPROFILE%\workspace\deno-examples</b>
> </pre>


## <span id="footnotes">Footnotes</span>

<span name="footnote_02">[2]</span> ***Downloads*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/denoland/deno/releases">deno-x86_64-pc-windows-msvc.zip</a>   <i>(24 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.33.0-64-bit.7z.exe</a>  <i>(41 MB)</i>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[deno_downloads]: https://github.com/denoland/deno/releases
[deno_land]: https://deno.land/
[git_docs]: https://git-scm.com/docs/git
[deno_relnotes]: https://github.com/denoland/deno/releases/tag/v1.13.1
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.33.0.txt
[github_markdown]: https://github.github.com/gfm/
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
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[scala3_examples]: https://github.com/michelou/dotty-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
