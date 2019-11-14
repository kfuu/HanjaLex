SwiftSQLite
===========

This is an SQLite wrapper/binding for Apple's Swift language, that's low level enough to be quick to learn and easy to use for anyone that has used sqlite previously.

Object oriented
---
As sqlite itself is largely laid out in an object oriented fashion, this library appropriately wraps to an appropriate object oriented design (e.g. ```*sqlite3_stmt``` and any C functional that takes ```*sqlite3_stmt``` as its first parameter are mapped to the Swift class ```SQLiteStatement```).

Setting up the database
---
The code is largely proof-of-concept and is intended as code drop to get you started. There are however to main functions you should find useful for initialising/manipulating databases: ```SQLiteDatabase.createDatabaseWithFilename(filename: String, withBlankDatabaseFilename blankDatabaseFilename: String)``` and ```SQLiteDatabase.deleteDatabase(filename: String)```. Both return a ```true``` or ```false``` value for whether or not the operation completed successfully.

Using a database
---
Once you have a working database setup, you'll have to initialize a ```SQLiteDatabase``` object first, as follows:

    let database = SQLiteDatabase()

This will usually then require you to open the database:

    database.open(filename: "myDatabse.sqlite")

This design is effectively a Swift/Object-oriented version of the lower level C SQLite, which presumes you make create a database but then open it later, hence why the open operation is not rolled into the constructor. Also, ```open``` returns a status code for whether the call was successful or not.

Example usage
---

```
let database = SQLiteDatabase()

database.open(filename: "myDatabse.sqlite")

let statement = SQLiteStatement(database: database)

if statement.prepare(sqlQuery: "SELECT * FROM tableName WHERE Id = ?") != .ok {
    
    /* handle error */
}

statement.bind(int: 1, at: 123)

if statement.step() == .row {

    /* do something with statement */

    let id: Int? = statement.int(at: 0)

    let string: String? = statement.string(at: 1)
    let bool: Bool? = statement.bool(at: 2)
    let date: Date? = statement.date(at: 3)
}

statement.finalizeStatement() /* not called finalize() due to destructor/language keyword */
```

Cocoapods
---
Unfortunately you can't use bridging headers (used to import the C types/methods from libsqlite3) in Swift framework targets which is how Swift cocoapods work, so you'll have to manually import this code into your project.

Work in progress
---
These classes are very bare at the moment. Feel free to flesh them out more, improve them and push your changes so I can incorporate them.

Copyright
---
You may do whatever you want to with these classes. NOTE: As of v2.0, for extra assurance, I've added the MIT license to all code file headers.

Contact
---
Contact me via [chris.m.simpson@icloud.com](mailto:chris.m.simpson@icloud.com) or [http://twitter.com/ChrisMSimpson](http://twitter.com/ChrisMSimpson) if you have any questions or improvements.
