import Foundation
import GRDB

extension AppDatabase {
    /// The database for the application
    static let shared = makeShared()
    
    private static func makeShared() -> AppDatabase {
        do {
            // Pick a folder for storing the SQLite database, as well as
            // the various temporary files created during normal database
            // operations (https://sqlite.org/tempfiles.html).
            let fileManager = FileManager()
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("database", isDirectory: true)

            // Support for tests: delete the database if requested
            if CommandLine.arguments.contains("-reset") {
                try? fileManager.removeItem(at: folderURL)
            }
            
            // Create the database folder if needed
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            // Connect to a database on disk
            // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
            let dbURL = folderURL.appendingPathComponent("KanuControl.sqlite")
            let dbPool = try DatabasePool(path: dbURL.path)
            
            print ("dbUrl: ", dbURL)
            
            // Create the AppDatabase
            let appDatabase = try AppDatabase(dbPool)
            
//            // Prepare the database with test fixtures if requested
//            if CommandLine.arguments.contains("-fixedTestData") {
//                try appDatabase.createFunktionForUI()
//                print ("createFunktion via commandline")
//            } else {
//                // Otherwise, populate the database if it is empty, for better
//                // demo purpose.
//                try appDatabase.createFunktionForUI()
//                print ("createFunktion")
//            }
            
            // Initial load of table Funktion
            let funktionCount = try dbPool.read {db in try Funktion.fetchCount(db)}
            if funktionCount == 0 {
                try appDatabase.createFunktionForUI()
                print ("createFunktion")
            } else {
                print ("Anzahl Einträge in Funktion: ", funktionCount)
            }
    
            
            
            return appDatabase
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
    
    /// Creates an empty database for SwiftUI previews
    static func empty() -> AppDatabase {
        // Connect to an in-memory database
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        let dbQueue = DatabaseQueue()
        return try! AppDatabase(dbQueue)
    }
}
