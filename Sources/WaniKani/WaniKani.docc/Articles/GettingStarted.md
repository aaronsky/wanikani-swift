# Getting Started

Initialize a client and get started with sending resources by fetching a summary. 

## Overview

### Get Your Access Token

In order to access the WaniKani API you must first create an API access token. Follow WaniKani's [own documentation on managing tokens](https://docs.api.wanikani.com/20170710/?shell#authentication) for more information on what to do. Keep in mind that securely storing tokens used with this package is the responsibility of the developer. 

### Create a Client

Creating a client object is as simple as calling the default initializer, and then assigning your token. 

```swift
let client = WaniKani()
client.token = "..." // Your WaniKani API access token
```

### Send a Resource

To send a resource, simply use ``WaniKani/WaniKani/send(_:pageOptions:)-1726r``. This sample is assuming you are sending from inside an async-throwing function. 

```swift
let response = try await client.send(.summary)
let pipelines = response.data
```

### Pagination

Some resources respond with a paged collection of data. As noted in WaniKani's [API documentation](https://docs.api.wanikani.com/20170710/?shell#pagination), the default maximum size of a paged response is 500 items, with Reviews and Subjects defaulting to 1000 items. In order to paginate on this data, you can do this:

```swift
var nextPage: PageOptions?
repeat {
    let response = try await client.send(.subjects(), pageOptions: nextPage)
    let subjects = response.data
    nextPage = subjects.page.next
} while nextPage != nil
```

### Rate Limiting

WaniKani limits all clients to [60 requests per minute](https://docs.api.wanikani.com/20170710/?shell#rate-limit). When the rate limit is exceeded, the client will throw ``ResponseError/rateLimitExceeded(limit:remaining:reset:)``. You can use the error's associated values in to implement a retry strategy.

```swift
do {
    // Some response that will throw a rateLimitExceeded error.
    let response = try await client.send(.subjects())
    print(response.data)
} catch ResponseError.rateLimitExceeded(let rateLimit, let rateRemaining, let rateReset) {
    print("Rate limit exceeded: will reset in \(rateReset.formatted(.relative(presentation: .numeric)))")
}
```
