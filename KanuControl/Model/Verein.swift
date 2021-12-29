//
//  Verein.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import GRDB

/// The Verein struct.
///
/// Identifiable conformance supports SwiftUI list animations, and type-safe
/// GRDB primary key methods.
/// Equatable conformance supports tests.
struct Verein: Identifiable, Equatable {
    /// The player id.
    ///
    /// Int64 is the recommended type for auto-incremented database ids.
    /// Use nil for players that are not inserted yet in the database.
    var id: Int64?
    var name: String
    var kurz: String?
    var bezirk: String?
    var strasse: String?
    var plz: String?
    var ort: String?
    var telefon: String?
    var homepage: String?
    var kz: String?
    var bank: String?
    var kontoinhaber: String?
    var iban: String?
    var bic: String?
    var rechtsform: String?
}

// MARK: - Persistence

/// Make Verein a Codable Record.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension Verein: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
        static let kurz = Column(CodingKeys.kurz)
        static let bezirk = Column(CodingKeys.bezirk)
        static let strasse = Column(CodingKeys.strasse)
        static let plz = Column(CodingKeys.plz)
        static let ort = Column(CodingKeys.ort)
        static let telefon = Column(CodingKeys.telefon)
        static let homepage = Column(CodingKeys.homepage)
        static let kz = Column(CodingKeys.kz)
        static let bank = Column(CodingKeys.bank)
        static let kontoinhaber = Column(CodingKeys.kontoinhaber)
        static let iban = Column(CodingKeys.iban)
        static let bic = Column(CodingKeys.bic)
        static let rechtsform = Column(CodingKeys.rechtsform)
    }
    
    /// Updates a verein id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// MARK: - Verein Database Requests

/// Define some Verein requests used by the application.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#requests>
/// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
extension DerivableRequest where RowDecoder == Verein {
    /// A request of vereine ordered by name ascending.
    ///
    /// For example:
    ///
    ///     let vereine: [Verein] = try dbWriter.read { db in
    ///         try Verein.all().orderedByName().fetchAll(db)
    ///     }
    func orderedByName() -> Self {
        // Sort by nameGesamt in a localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
        order(
            Verein.Columns.name.asc,
            Verein.Columns.name.collating(.localizedCaseInsensitiveCompare))
    }
}
