# Database Design

## Database

`uber_ride_analysis` is a PostgreSQL relational database.

## Relationships

- One customer can have many rides.
- One driver can fulfill many rides.
- One driver can be assigned one or more vehicles over time.
- One vehicle can be used for many rides.
- One location can be used by many rides as either a pickup or drop-off point.
- Each ride can have at most one payment.
- A payment belongs to exactly one ride.
- A ride can have one customer rating and one driver rating.

## Design Decisions

- `BIGSERIAL` keys provide simple locally generated identifiers.
- Foreign keys preserve relationships between operational records.
- `CHECK` constraints restrict statuses, vehicle types, ratings, distances, and amounts.
- `TIMESTAMPTZ` stores event times with timezone information.
- Payments use a unique `ride_id` because one ride has one payment record in this project scope.
- Views expose common analytical shapes without duplicating stored data.
- Locations are normalized so route and zone analysis can use stable foreign keys.
- Ratings are normalized so customer and driver feedback can be analyzed independently.
- Indexes support customer, driver, status, time, location, and payment-status lookups.

## Script Order

Tables must exist before data can be inserted. Data must exist before meaningful views and reports can be used. Functions and triggers are defined after the tables they operate on. Indexes are applied last so the schema is easy to inspect during setup.
