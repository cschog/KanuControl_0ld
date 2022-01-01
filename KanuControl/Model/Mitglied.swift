//
//  Mitglied.swift
//  KanuControl
//
//  Created by Christoph Schog on 31.12.21.
//

import GRDB

/// The Verein struct.
///
/// Identifiable conformance supports SwiftUI list animations, and type-safe
/// GRDB primary key methods.
/// Equatable conformance supports tests.
struct Mitglied: Identifiable, Equatable {
    /// The player id.
    ///
    /// Int64 is the recommended type for auto-incremented database ids.
    /// Use nil for mitglieder that are not inserted yet in the database.
    var id: Int64?
    var personenId: Int?
    var vereinId: Int?
    var funktionId: Int?
}

// MARK: - Persistence

/// Make Verein a Codable Record.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension Mitglied: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let personenId = Column(CodingKeys.personenId)
        static let vereinId = Column(CodingKeys.vereinId)
        static let funktionId = Column(CodingKeys.funktionId)
 
    }
    
    /// Updates a mitglied id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

//// MARK: - Verein Database Requests
//
///// Define some Mitglied requests used by the application.
/////
///// See <https://github.com/groue/GRDB.swift/blob/master/README.md#requests>
///// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
//extension DerivableRequest where RowDecoder == Mitglied {
//    /// A request of vereine ordered by name ascending.
//    ///
//    /// For example:
//    ///
//    ///     let vereine: [Verein] = try dbWriter.read { db in
//    ///         try Verein.all().orderedByName().fetchAll(db)
//    ///     }
//    func orderedByName() -> Self {
//        // Sort by nameGesamt in a localized case insensitive fashion
//        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
//        order(
//            Mitglied.Columns.name.asc,
//            Mitglied.Columns.name.collating(.localizedCaseInsensitiveCompare))
//    }
//}

