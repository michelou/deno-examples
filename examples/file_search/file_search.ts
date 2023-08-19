import yargs from "https://deno.land/x/yargs@v17.7.2-deno/deno.ts";
import * as path from "https://deno.land/std@0.198.0/path/mod.ts";

interface Yargs<ArgvReturnType> {
  describe: (param: string, description: string) => Yargs<ArgvReturnType>;
  demandOption: (required: string[]) => Yargs<ArgvReturnType>;
  argv: ArgvReturnType;
}

interface UserArguments {
  text: string;
  extension?: string;
  replace?: string;
}

const userArguments: UserArguments =
  (yargs(Deno.args) as unknown as Yargs<UserArguments>)
    .describe("text", "the text to search for within the current directory")
    .describe("extension", "a file extension to match against")
    .describe("replace", "the text to replace any matches with")
    .demandOption(["text"])
    .argv;

const IGNORED_DIRECTORIES = new Set([".git"]);

interface FilterOptions {
  extension?: string;
}

async function getFilesList(
  directory: string,
  options: FilterOptions = {},
): Promise<string[]> {
  const foundFiles: string[] = [];
  for await (const fileOrFolder of Deno.readDir(directory)) {
    if (fileOrFolder.isDirectory) {
      if (IGNORED_DIRECTORIES.has(fileOrFolder.name)) {
        // Skip this folder, it's in the ignore list.
        continue;
      }
      // If it's not ignored, recurse and search this folder for files.
      const nestedFiles = await getFilesList(
        path.join(directory, fileOrFolder.name),
        options,
      );
      foundFiles.push(...nestedFiles);
    } else {
      // We know it's a file, and not a folder.

      // True if we weren't given an extension to filter, or if we were and the file's extension matches the provided filter.
      const shouldStoreFile = !options.extension ||
        path.extname(fileOrFolder.name) === `.${options.extension}`;

      if (shouldStoreFile) {
        foundFiles.push(path.join(directory, fileOrFolder.name));
      }
    }
  }
  return foundFiles;
}

const files = await getFilesList(Deno.cwd(), {
  extension: userArguments.extension,
});

interface Match {
  file: string;
  lineNumber: number;
  lineText: string;
}
const matches = new Map<string, Set<Match>>();

for (const file of files) {
  const contents = await Deno.readTextFile(file);
  const lines = contents.split("\n");
  lines.forEach((line, index) => {
    if (line.includes(userArguments.text)) {
      const matchesForFile = matches.get(file) || new Set<Match>();
      matchesForFile.add({
        file,
        lineNumber: index + 1,
        lineText: line,
      });
      matches.set(file, matchesForFile);
    }
  });

  if (userArguments.replace) {
    const newContents = contents.replaceAll(
      userArguments.text,
      userArguments.replace,
    );
    await Deno.writeTextFile(file, newContents);
  }
}

for (const [fileName, fileMatches] of matches) {
  console.log(fileName);
  fileMatches.forEach((m) => {
    console.log("=>", m.lineNumber, m.lineText.trim());
  });
}
