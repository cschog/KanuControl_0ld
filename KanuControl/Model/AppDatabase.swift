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
    
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("KanuControl_DB_V1.0") { db in
            // Create table "land"      ---> fertig
                        try db.create(table: "land") { t in
                            t.column("laenderCode", .text)
                                .primaryKey()
                            t.column("land", .text).notNull()
                            t.column("flagge", .blob)
                        }
            
            // Create table "person"  ---> fertig
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
                t.column("nameGesamt", .text)
                    .notNull()
                    .indexed()
                    .collate(.localizedCaseInsensitiveCompare)
                t.column("status", .boolean).notNull()
                t.column("statusDatum", .text).notNull()
                t.column("bank", .text)
                t.column("iban", .text)
                t.column("bic", .text)
            }
            
            // Create table "verein"   ---> fertig
            try db.create(table: "verein") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text)
                    .notNull()
                    .collate(.localizedCaseInsensitiveCompare)
                t.column("kurz", .text)
                t.column("bezirk", .text)
                t.column("strasse", .text)
                t.column("plz", .text)
                t.column("ort", .text)
                t.column("telefon", .text)
                t.column("homepage", .text)
                t.column("kz", .text)         // kz = Vereinskennzeichen vom LSB
                t.column("bank", .text)
                t.column("kontoinhaber", .text)
                t.column("iban", .text)
                t.column("bic", .text)
                t.column("rechtsform", .text)   // gemeinnütziger Verein, ... (später eigene Tabelle)
            }
            
            // Create table "kjpPosition"   ---> fertig
            try db.create(table: "kjpPosition") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("kurzname", .text)
                t.column("name", .text)
                    .notNull()
            }
            
            // Create table "veranstaltung"     ---> fertig
            try db.create(table: "veranstaltung") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("aktiv", .boolean)
                t.column("titel", .text)
                t.column("artDerUnterkunft", .text)   // Default = Campingplatz
                t.column("artDerVerpflegung", .text)    // Default = Selbstversorger, Vollpension, Halbpension
                t.column("plz", .text)
                t.column("ort", .text)
                t.column("laenderCode", .text)
                    .references("land")             // DE = Deutschland
                t.column("beginn", .text)
                t.column("ende", .text)
                t.column("planMann", .integer)  // geplante Anzahl der zu fördernden Teilnehmer, männlich
                t.column("planFrau", .integer)  // geplante Anzahl der zu fördernden Teilnehmer, weiblich
                t.column("istMann", .integer)   // tatsächliche Anzahl der zu fördernden Teilnehmer, männlich
                t.column("istFrau", .integer)   // tatsächliche Anzahl der zu fördernden Teilnehmer, weiblich
                t.column("planMitarbeiterMann", .integer)
                t.column("planMitarbeiterFrau", .integer)
                t.column("istMitarbeiterMann", .integer)
                t.column("istMitarbeiterFrau", .integer)
                t.column("istMitarbeiterDivers", .integer)
                t.column("kjpPositionId", .integer)
                    .references("kjpPosition")
                t.column("leiterId", .integer)
                    .references("person")
                t.column("vereinId", .integer)  // Ausrichter oder ausrichtender Verein
                    .references("verein")
                t.column("internationaleJugendarbeit", .boolean)
                t.column("thematischerSchwerpunkt", .integer)       // LSB Erhebungsbogen
                t.column("durchführungsort", .integer)              // Erhebungsbogen
                
            }
            
            // Create table "finanzen"
            try db.create(table: "finanzen") { t in
                t.autoIncrementedPrimaryKey("id")
                    .references("veranstaltung", onDelete: .cascade)
                t.column("ausgabenVerpflegungPlan", .double)
                t.column("ausgabenVerpflegungIst", .double)
                t.column("ausgabenUnterkunftPlan", .double)
                t.column("ausgabenUnterkunftIst", .double)
                t.column("ausgabenFahrkostenPlan", .double)
                t.column("ausgabenFahrkostenIst", .double)
                t.column("ausgabenMaterialPlan", .double)
                t.column("ausgabenMaterialIst", .double)
                t.column("ausgabenHonorarkostenPlan", .double)
                t.column("ausgabenHonorarkostenIst", .double)
                t.column("ausgabenMietePlan", .double)
                t.column("ausgabenMieteIst", .double)
                t.column("ausgabenSonstigeKostenPlan", .double)
                t.column("ausgabenSonstigeKostenIst", .double)
                t.column("einnahmenTeilnehmerBeitraegePlan", .double)
                t.column("einnahmenTeilnehmerBeitraegeIst", .double)
                t.column("einnahmenSpendePlan", .double)
                t.column("einnahmenSpendeIst", .double)
                t.column("einnahmenPfandPlan", .double)
                t.column("einnahmenPfandIst", .double)
                t.column("einnahmenSonstigeEinnahmenPlan", .double)
                t.column("einnahmenSonstigeEinnahmenIst", .double)
                t.column("einnahmenEigenleistungPlan", .double)
                t.column("einnahmenEigenleistungIst", .double)
                t.column("einnahmenZuschussKJPPlan", .double)
                t.column("einnahmenZuschussKJPIst", .double)
                t.column("einnahmenSonstigerZuschussPlan", .double)
                t.column("einnahmenSonstigerZuschussIst", .double)
                t.column("gesamtKostenPlan", .double)
                t.column("gesamtKostenIst", .double)
                t.column("gesamtEinnahmenPlan", .double)
                t.column("gesamtEinnahmenIst", .double)
            }
            
            // Create table "reisekosten"       ---> fertig
            try db.create(table: "reisekosten") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("veranstaltungsId", .integer)
                    .notNull()
                    .indexed()
                    .references("veranstaltung")
                t.column("personId", .integer)
                    .notNull()
                    .indexed()
                    .references("person", onDelete: .cascade)
                t.column("reiseVon", .text) // Abfahrtsort
                t.column("kmFahrer", .integer)
                t.column("kmPauschaleFahrer", .double)
                t.column("kmPauschaleMitfahrer", .double)
                t.column("kmVorOrt", .integer)
                t.column("vorschuss", .double)
            }
            
            // Create table "funktion"      ---> fertig
            try db.create(table: "funktion") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()       // z.B. Jugendleiter oder Wanderwart, ...
            }
            
            // Create relationship "mitglied"     ---> fertig
            try db.create(table: "mitglied") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("personId", .integer)
                    .notNull()
                    .indexed()
                    .references("person", onDelete: .cascade)
                t.column("vereinId", .integer)
                    .notNull()
                    .indexed()
                    .references("verein", onDelete: .setNull)
                t.column("funktionId", .integer)        // Funktion im Verein
                    .notNull()
                    .indexed()
                    .references("funktion", onDelete: .setNull)
            }
            
            // Create relationship "mitfahrer"      ---> fertig
            try db.create(table: "mitfahrer") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("personId", .integer)
                    .notNull()
                    .indexed()
                    .references("person", onDelete: .cascade)
                t.column("reisekostenId", .integer)
                    .notNull()
                    .indexed()
                    .references("reisekosten")
                t.column("kmMitfahrer", .integer)
            }
            
            // Create relationship "teilnahme"
            try db.create(table: "teilnahme") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("personId", .integer)
                    .notNull()
                    .indexed()
                    .references("person", onDelete: .cascade)
                t.column("veranstaltungsId", .integer)
                    .notNull()
                    .indexed()
                    .references("veranstaltung")
                t.column("funktionId", .integer)
                    .notNull()
                    .indexed()
                    .references("funktion")     // Funktion während der Veranstaltung
                t.column("beitrag", .double)    // Teilnehmer-Beitrag
                t.column("ermaessigung", .double)   //
            }
        }
        return migrator
    }
}

// MARK: - Database Access: Writes

extension AppDatabase {
    /// A validation error that prevents some players from being saved into
    /// the database.
    enum ValidationError: LocalizedError {
        case missingName
        case missingId
        
        var errorDescription: String? {
            switch self {
            case .missingName:
                return "Bitte Name eingeben"
            case .missingId:
                return "Keine ID gefunden"
            }
        }
    }
    
// -------- Person -----------
    /// Saves (inserts or updates) a person. When the method returns, the
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
    
// ---------- Verein -------------------
    
    /// Saves (inserts or updates) a verein. When the method returns, the
    /// verein is present in the database, and its id is not nil.
    func saveVerein(_ verein: inout Verein) throws {
        if verein.name.isEmpty {
            throw ValidationError.missingName
        }
        try dbWriter.write { db in

            try verein.save(db)
        }
    }

    /// Delete the specified verein
    func deleteVerein(ids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try Verein.deleteAll(db, ids: ids)
        }
    }

    /// Delete all Vereine
    func deleteAllVereine() throws {
        try dbWriter.write { db in
            _ = try Verein.deleteAll(db)
        }
    }
    
    // ---------- Funktion -------------------
        
        /// Saves (inserts or updates) a funktion. When the method returns, the
        /// funktion is present in the database, and its name is not nil.
        func saveFunktion(_ funktion: inout Funktion) throws {
            if funktion.name.isEmpty {
                throw ValidationError.missingName
            }
            try dbWriter.write { db in

                try funktion.save(db)
            }
        }

        /// Delete the specified funktion
        func deleteFunktion(ids: [Int64]) throws {
            try dbWriter.write { db in
                _ = try Funktion.deleteAll(db, ids: ids)
            }
        }

        /// Delete all Funktion(en)
        func deleteAllFunktion() throws {
            try dbWriter.write { db in
                _ = try Funktion.deleteAll(db)
            }
        }
    
    static let uiFunktion = [
        Funktion(id: nil, name: "Vorsitzende(r)"),
        Funktion(id: nil, name: "Geschäftsführer:in"),
        Funktion(id: nil, name: "Schatzmeister:in"),
        Funktion(id: nil, name: "Jugendwart:in"),
        Funktion(id: nil, name: "Wanderwart:in"),
        Funktion(id: nil, name: "Bootshauswart:in"),
        Funktion(id: nil, name: "Schriftwart:in"),
        Funktion(id: nil, name: "Sportwart:in")]

    func createFunktionForUI() throws {
        try dbWriter.write { db in
            try AppDatabase.uiFunktion.forEach { funktion in
                _ = try funktion.inserted(db) // insert but ignore inserted id
            }
        }
    }
    
    // ---------- Mitglied -------------------
        
        /// Saves (inserts or updates) a mitglied. When the method returns, the
        /// mitglied is present in the database, and its id is not nil.
        func saveMitglied(_ mitglied: inout Mitglied) throws {
            if (mitglied.personenId == nil || mitglied.vereinId == nil) {
                throw ValidationError.missingId
            }
            try dbWriter.write { db in

                try mitglied.save(db)
            }
        }

        /// Delete the specified verein
        func deleteMitglied(ids: [Int64]) throws {
            try dbWriter.write { db in
                _ = try Mitglied.deleteAll(db, ids: ids)
            }
        }

        /// Delete all Vereine
        func deleteAllMitglieder() throws {
            try dbWriter.write { db in
                _ = try Mitglied.deleteAll(db)
        }
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
