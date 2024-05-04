# Baklava Server

 Welcome to Baklava Server! Baklava Server is a feature flag management system backend built on [Vapor](https://github.com/vapor/vapor) and powered by [Fluent](https://github.com/vapor/fluent).

---

#### Getting Started
 To set up your Baklava server, you'll need some essentials:
 - Swift installed on your machine (You can find installation instructions on Swift.org)
 - Familiarity with Swift development
 - A database solution (compatible with your chosen driver)

 A mongo configuration is provided in the `App/configure.swift`

 ```Swift
     try app.databases.use(.mongo(
		connectionString: "[YOUR_MONGO_HOST]"), as: .mongo)
 ```

 To easily interact with the Baklava Server from a client, you can use the [Baklava Swift SDK]("https://github.com/cembaykara/baklava-swift"). It provides convenient methods for accessing the server's endpoints and handling responses.

---
#### Contributing and Development
 We welcome contributions to Baklava! If you have improvements or additional features in mind, we encourage you to submit a pull request.
