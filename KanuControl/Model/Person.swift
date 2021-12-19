import GRDB

/// The Person struct.
///
/// Identifiable conformance supports SwiftUI list animations, and type-safe
/// GRDB primary key methods.
/// Equatable conformance supports tests.
struct Person: Identifiable, Equatable {
    /// The player id.
    ///
    /// Int64 is the recommended type for auto-incremented database ids.
    /// Use nil for players that are not inserted yet in the database.
    var id: Int64?
    var name: String
    var email: String
    var age: Int
}

// MARK: - Persistence

/// Make User a Codable Record.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension Person: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
        static let email = Column(CodingKeys.email)
        static let age = Column(CodingKeys.age)
    }
    
    /// Updates a person id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// MARK: - Person Database Requests

/// Define some person requests used by the application.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#requests>
/// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
extension DerivableRequest where RowDecoder == Person {
    /// A request of persons ordered by name.
    ///
    /// For example:
    ///
    ///     let persons: [Person] = try dbWriter.read { db in
    ///         try Person.all().orderedByName().fetchAll(db)
    ///     }
    func orderedByAgeUp() -> Self {
        // Sort by name in a localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
        order(
            Person.Columns.age.asc,
            Person.Columns.name.collating(.localizedCaseInsensitiveCompare))
    }
    
    /// A request of persons ordered by age.
    ///
    /// For example:
    ///
    ///     let persons: [Person] = try dbWriter.read { db in
    ///         try Person.all().orderedByName().fetchAll(db)
    ///     }
    ///     let oldestPerson: Person? = try dbWriter.read { db in
    ///         try Person.all().orderedByAge().fetchOne(db)
    ///     }
    func orderedByAgeDown() -> Self {
        // Sort by descending age, and then by name, in a
        // localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
        order(
            Person.Columns.age.desc,
            Person.Columns.name.collating(.localizedCaseInsensitiveCompare))
    }
}
