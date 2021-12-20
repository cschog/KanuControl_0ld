import Combine
import GRDB
import GRDBQuery

/// A person request can be used with the `@Query` property wrapper in order to
/// feed a view with a list of persons.
///
/// For example:
///
///     struct MyView: View {
///         @Query(PersonRequest(ordering: .byAgeDown)) private var persons: [Person]
///
///         var body: some View {
///             List(persons) { person in ... )
///         }
///     }
struct PersonRequest: Queryable {
    enum Ordering {
        case byName
    }
    
    /// The ordering used by the person request.
    var ordering: Ordering
    
    // MARK: - Queryable Implementation
    
    static var defaultValue: [Person] { [] }
    
    func publisher(in appDatabase: AppDatabase) -> AnyPublisher<[Person], Error> {
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
    func fetchValue(_ db: Database) throws -> [Person] {
        switch ordering {
        case .byName:
            return try Person.all().orderedByName().fetchAll(db)
        }
    }
}
