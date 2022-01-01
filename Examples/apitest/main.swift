import Foundation
import WaniKani

let client = WaniKani()
client.token = "..."

Task {
    do {
        exit(0)
    } catch {
        print(error)
        exit(1)
    }
}

RunLoop.main.run()
