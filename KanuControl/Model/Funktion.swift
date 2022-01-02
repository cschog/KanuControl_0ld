//
//  Funktion.swift
//  KanuControl
//
//  Created by Christoph Schog on 01.01.22.
//

import GRDB

/// The Funktion struct.
///
/// Identifiable conformance supports SwiftUI list animations, and type-safe
/// GRDB primary key methods.
/// Equatable conformance supports tests.
struct Funktion: Identifiable, Equatable {
    /// The funktion id.
    ///
    /// Int64 is the recommended type for auto-incremented database ids.
    /// Use nil for funktion that are not inserted yet in the database.
    var id: Int64?
    var name: String
}

// MARK: - Persistence

/// Make Funktion a Codable Record.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension Funktion: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
    }
    
    /// Updates a funktion id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// MARK: - Funktion Database Requests

/// Define some Funktion requests used by the application.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#requests>
/// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
extension DerivableRequest where RowDecoder == Funktion {
    /// A request of vereine ordered by name ascending.
    ///
    /// For example:
    ///
    ///     let funktionen: [Funktion] = try dbWriter.read { db in
    ///         try Funktion.all().orderedByName().fetchAll(db)
    ///     }
    func orderedByName() -> Self {
        // Sort by name in a localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
        order(
            Funktion.Columns.name.asc,
            Funktion.Columns.name.collating(.localizedCaseInsensitiveCompare))
    }
}

