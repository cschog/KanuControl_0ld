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
    var vorname: String
    var geburtstag: String?
    var sex: String?
    var strasse: String?
    var plz: String?
    var ort: String?
    var telefonFestnetz: String?
    var telefonMobil: String?
    var email: String?
    var nameGesamt: String // = Name, Vorname
    var status: Bool = true // default aktives Mitglied (= true) oder inaktiv (= false)
    var statusDatum: String // Datum der Statusänderung, bei der Ersterfassung ist das das Erfassungsdatum
    var bank: String?
    var iban: String?
    var bic: String?
}


// MARK: - Persistence

/// Make User a Codable Record.
///
/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension Person: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
        static let vorname = Column(CodingKeys.vorname)
        static let geburtstag = Column(CodingKeys.geburtstag)
        static let sex = Column(CodingKeys.sex)
        static let strasse = Column(CodingKeys.strasse)
        static let plz = Column(CodingKeys.plz)
        static let ort = Column(CodingKeys.ort)
        static let telefonFestnetz = Column(CodingKeys.telefonFestnetz)
        static let telefonMobil = Column(CodingKeys.telefonMobil)
        static let email = Column(CodingKeys.email)
        static let nameGesamt = Column(CodingKeys.nameGesamt)
        static let status = Column(CodingKeys.status)
        static let statusDatum = Column(CodingKeys.statusDatum)
        static let bank = Column(CodingKeys.bank)
        static let iban = Column(CodingKeys.iban)
        static let bic = Column(CodingKeys.bic)
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
    /// A request of persons ordered by nameGesamt ascending.
    ///
    /// For example:
    ///
    ///     let persons: [Person] = try dbWriter.read { db in
    ///         try Person.all().orderedByName().fetchAll(db)
    ///     }
    func orderedByName() -> Self {
        // Sort by nameGesamt in a localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
        order(
            Person.Columns.nameGesamt.asc,
            Person.Columns.nameGesamt.collating(.localizedCaseInsensitiveCompare))
    }
    
    /// A request of persons ordered by age descending
    ///
    /// For example:
    ///
    ///     let persons: [Person] = try dbWriter.read { db in
    ///         try Person.all().orderedByName().fetchAll(db)
    ///     }
    ///     let oldestPerson: Person? = try dbWriter.read { db in
    ///         try Person.all().orderedByAge().fetchOne(db)
    ///     }
//    func orderedByAgeDown() -> Self {
//        // Sort by descending age, and then by name, in a
//        // localized case insensitive fashion
//        // See https://github.com/groue/GRDB.swift/blob/master/README.md#string-comparison
//        order(
//            Person.Columns.age.desc,
//            Person.Columns.name.collating(.localizedCaseInsensitiveCompare))
//    }
}
