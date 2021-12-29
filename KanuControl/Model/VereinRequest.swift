//
//  VereinRequest.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import Combine
import GRDB
import GRDBQuery

/// A verein request can be used with the `@Query` property wrapper in order to
/// feed a view with a list of vereine.

struct VereinRequest: Queryable {
    enum Ordering {
        case byName
    }
    
    /// The ordering used by the verein request.
    var ordering: Ordering
    
    // MARK: - Queryable Implementation
    
    static var defaultValue: [Verein] { [] }
    
    func publisher(in appDatabase: AppDatabase) -> AnyPublisher<[Verein], Error> {
        // Build the publisher from the general-purpose read-only access
        // granted by `appDatabase.databaseReader`.
        // Some apps will prefer to call a dedicated method of `appDatabase`.
        ValueObservation
            .tracking(fetchValue(_:))
            .publisher(
                in: appDatabase.databaseReader,
                // The `.immediate` scheduling feeds the view right on
                // subscription, and avoids an undesired animation when the
                // application starts.
                scheduling: .immediate)
            .eraseToAnyPublisher()
    }
    
    // This method is not required by Queryable, but it makes it easier
    // to test UserRequest.
    func fetchValue(_ db: Database) throws -> [Verein] {
        switch ordering {
        case .byName:
            return try Verein.all().orderedByName().fetchAll(db)
        }
    }
}
