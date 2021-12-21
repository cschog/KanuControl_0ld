import Combine
import Foundation
import GRDB

/// AppDatabase lets the application access the database.
///
/// It applies the pratices recommended at
/// <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
struct AppDatabase {
    /// Creates an `AppDatabase`, and make sure the database schema is ready.
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }
    
    /// Provides access to the database.
    ///
    /// Application can use a `DatabasePool`, while SwiftUI previews and tests
    /// can use a fast in-memory `DatabaseQueue`.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections>
    private let dbWriter: DatabaseWriter
    
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md>
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("createPerson") { db in
            // Create a table
            // See https://github.com/groue/GRDB.swift#create-tables
            try db.create(table: "person") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("vorname", .text).notNull()
                t.column("geburtstag", .text)
                t.column("sex", .text)
                t.column("strasse", .text)
                t.column("plz", .text)
                t.column("ort", .text)
                t.column("telefonFestnetz", .text)
                t.column("telefonMobil", .text)
                t.column("email", .text)
                t.column("nameGesamt", .text).notNull()
                t.column("status", .text).notNull()
                t.column("statusDatum", .text).notNull()
                t.column("bank", .text)
                t.column("iban", .text)
                t.column("bic", .text)
            }
        }
        
        // Migrations for future application versions will be inserted here:
        // migrator.registerMigration(...) { db in
        //     ...
        // }
        
        return migrator
    }
}

// MARK: - Database Access: Writes

extension AppDatabase {
    /// A validation error that prevents some players from being saved into
    /// the database.
    enum ValidationError: LocalizedError {
        case missingName
        
        var errorDescription: String? {
            switch self {
            case .missingName:
                return "Please provide a name"
            }
        }
    }
    
    /// Saves (inserts or updates) a player. When the method returns, the
    /// person is present in the database, and its id is not nil.
    func savePerson(_ person: inout Person) throws {
        if person.name.isEmpty {
            throw ValidationError.missingName
        }
        try dbWriter.write { db in
            person.nameGesamt = person.name + ", " + person.vorname
            
            // Create Date
            let date = Date()

            // Create Date Formatter
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "YYYY-MM-dd"

            // Convert Date to String
            // dateFormatter.string(from: date)
            
            person.status = true
            person.statusDatum = dateFormatter.string(from: date)
            try person.save(db)
        }
    }
    
    /// Delete the specified person
    func deletePerson(ids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try Person.deleteAll(db, ids: ids)
        }
    }
    
    /// Delete all Persons
    func deleteAllPersons() throws {
        try dbWriter.write { db in
            _ = try Person.deleteAll(db)
        }
    }
    
    /// Refresh all persons (by performing some random changes, for demo purpose).
    func refreshPersons() throws {

    }
}

// MARK: - Database Access: Reads

// This demo app does not provide any specific reading method, and instead
// gives an unrestricted read-only access to the rest of the application.
// In your app, you are free to choose another path, and define focused
// reading methods.
extension AppDatabase {
    /// Provides a read-only access to the database
    var databaseReader: DatabaseReader {
        dbWriter
    }
}
