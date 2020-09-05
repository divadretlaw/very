import Foundation
import Dispatch

let very = Very()

do {
    if let pathIndex = CommandLine.arguments.firstIndex(of: "--path") {
        if pathIndex.advanced(by: 1) < CommandLine.arguments.count {
            let path = CommandLine.arguments[pathIndex.advanced(by: 1)]
            try Configuration.load(path: path)
        } else {
            very.help()
            exit(0)
        }
    } else {
        try Configuration.load()
    }
} catch {
    Log.fatal("Unable to load configuration.", error.localizedDescription)
}

#if DEBUG
very.execute()
#else
very.execute()
#endif
