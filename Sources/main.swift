import Shell

var prefix: String? = ProcessInfo.processInfo.environment["SWIFTINSTALL"]
var buildPath: String = ".build"
var testable: Bool = false

if let prefix {
 do {
  let destination = try Folder(path: prefix)
  var folder = Folder.current
  var inputs = CommandLine.arguments[1...]

  if let argument = inputs.first, argument.hasPrefix("-") {
   let option = argument.drop(while: { $0 == "-" })
   switch option {
   case "t", "testable":
    testable = true
    inputs.removeFirst()
   default:
    exit(1, "unknown argument at: \(argument)")
   }
  }
  
  if inputs.count > 0, !inputs[0].hasPrefix("-") {
   folder = try Folder(path: inputs.removeFirst())
  }

  folder.set()

  let defaults = ["-c", testable ? "debug" : "release", "--build-path", buildPath]

  let buildArguments =
   ["build"] + defaults +
   (inputs.wrapped ?? ["-Xcc", "-Ofast", "-Xswiftc", "-O"])

  // TODO: add verbosity option
  try process(.swift, with: buildArguments)

  let outputArguments = ["build"] + defaults + ["--show-bin-path"]
  let binPath = try output(.swift, with: outputArguments)
  let binFolder = try Folder(path: binPath)

  #if os(Linux)
  let hasDot = folder.name.contains(".")
  let binaries =
   hasDot ? binFolder.files.map { $0 } :
   binFolder.files.filter { !$0.name.contains(".") }
  #else
  let binaries =
   try binFolder.files.filter { try $0[.contentType] == .unixExecutable }
  #endif

  // FIXME: find actual binary name, without fuzzy matching based on folder name
  if let binary =
   binaries.first(
    where: { $0.name.lowercased() == folder.name.lowercased() }
   ) ??
   binaries.compactMap({ file -> (File, [String.Index])? in
    guard let range =
     folder.name.lowercased().fuzzyMatch(file.name.lowercased()),
     range.count > 3
    else { return nil }
    return (file, range)
   })
   .sorted(by: { $0.1.count < $1.1.count })
   .first?.0 {
   let name = binary.name
   // TODO: Replace instead of delete / copy
   if let previous = try? destination.file(named: name) {
    try previous.delete()
   }
   
   try binary.move(to: destination)
   let path = try destination.file(named: name)
   
   exit(0, path)
  }
 } catch {
  exit(error)
 }
} else {
 print(
  "to use, add `export SWIFTINSTALL=path/to/binaries` to your shell profile"
 )
 exit(1, "missing environment variable $SWIFTINSTALL")
}
