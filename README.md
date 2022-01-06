# WaniKani

![Build Status](https://github.com/aaronsky/wanikani-swift/workflows/build/badge.svg)

A Swift library and client for the WaniKani REST API. It currently supports **Version 2 Revision 20170710** of the API.

```swift
import WaniKani

let client = WaniKani()
client.token = "..."

let response = try await client.send(.reviews(updatedAfter: Date()))
let reviews = response.data
print(reviews)
```

## Usage

[Getting Started](./Sources/WaniKani/WaniKani.docc/Articles/GettingStarted.md)

## References

-   [WaniKani](https://wanikani.com/)
-   [WaniKani API Documentation](https://docs.api.wanikani.com)

## License

WaniKani for Swift is released under Apache License 2.0. [See LICENSE](https://github.com/aaronsky/wanikani-swift/blob/master/LICENSE) for details. WaniKani data is subject to the [Terms of Use](https://www.wanikani.com/terms).
