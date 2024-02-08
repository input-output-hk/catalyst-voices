---
    title: 0006 Cursor-based pagination for Catalyst Data Service
    adr:
        author: Oleksandr Prokhorenko
        created: 05-Feb-2024
        status:  accepted
    tags:
        - api
---

## Context

Our API currently lacks a pagination mechanism, leading to inefficiencies in data retrieval processes,
especially when dealing with large datasets.
This absence has resulted in longer load times and
a strained user experience, prompting the need for a scalable solution to manage data access and navigation effectively.

## Assumptions

* The assumption that cursor-based pagination will be universally supported and understood by all clients consuming our API.
* Assuming our database and backend infrastructure can efficiently support cursor-based operations without
 significant refactoring or performance degradation.
* The expectation that data growth will continue at its current pace or accelerate,
necessitating a robust solution.

## Decision

We are proposing to introduce a cursor-based pagination system to our API.
This system will rely on ans enabling clients to efficiently fetch data in chunks and
understand when more data is available:

* `limit` - This establishes a restriction on the quantity of objects to be returned,
with a minimum of 1 and a maximum no greater than 100.
* `starting_after`- the cursor to start returning results from,
* `ending_before`- the cursor to stop returning results at.

The JSON response structure will include fields such as

* `data` - containing the requested data.
  Data must always be deterministically sorted,
such that id always return in the same order, regardless of the pagination,
* `has_more` - indicating whether more data is available,

Example JSON response:

```json
{
  "data": [
    {
      "id": "item1",
      "attribute": "value"
    },
    {
      "id": "item2",
      "attribute": "value"
    }
  ],
  "has_more": true
}
```

### Example API Calls

These examples demonstrate how clients would use the API to navigate through data pages efficiently,
utilizing cursor-based pagination.

#### Initial Fetch with Limit

Request: GET `/api/resource?limit=2`
This retrieves the first two items of the dataset.

#### Fetching the Next Page

Request: GET `/api/resource?limit=2&starting_after=eyJpZCI6Iml0ZW0xMDAifQ==`
Using the next_cursor from the previous response, this fetches the next two items.

#### Fetching the Previous Page

Request: GET `/api/resource?limit=2&ending_before=eyJpZCI6Iml0ZW0yMDAifQ==`

Using a `prev_cursor` value, this would fetch the two items before the current page,
assuming `prev_cursor` is implemented and provided in your system.

These examples demonstrate how clients would use the API to navigate through data pages efficiently,
utilizing cursor-based pagination.

## Risks

* Implementing cursor-based pagination might introduce complexity for clients unfamiliar with this approach,
potentially affecting adoption or requiring additional documentation and support.
* Potential risks in the backend implementation, such as incorrect cursor handling,
could lead to data inconsistencies, including skipped items or duplicate data.
* The assumption regarding our backend's ability to support this efficiently might be overly optimistic,
leading to unforeseen performance issues.

## Consequences

* Pagination will significantly improve data handling efficiency, particularly for large datasets,
enhancing the user experience by reducing load times and improving data manageability.
* This change might increase the initial learning curve for new API consumers,
requiring comprehensive documentation and possibly support resources to aid in integration.
* Backend development practices may need to adapt to account for the new pagination logic,
potentially affecting development timelines for new features or adjustments to existing data models.

## More Information

Implementing a system similar to Stripe not only aligns us with industry standards but
also ensures that we are adopting proven practices for scalability and efficiency.

* [Stripe API Documentation on Pagination](https://stripe.com/docs/api/pagination)
* [Using Cursors for Pagination (PostgreSQL documentation)](https://www.postgresql.org/docs/current/plpgsql-cursors.html)
* [Cursor-Based Pagination: A Better Way to Retrieve Data](https://www.sitepoint.com/paginating-real-time-data-cursor-based-pagination/)
* [Offset vs Cursor-Based Pagination: Choosing the Best Approach](https://medium.com/@maryam-bit/offset-vs-cursor-based-pagination-choosing-the-best-approach-2e93702a118b)
* [Pagination — Offset vs Cursor in MySQL](https://bojithapiyathilake.medium.com/pagination-offset-vs-cursor-in-mysql-92cbf1a02cfa)
* [Web API Pagination | Offset-based vs Cursor-based](https://www.youtube.com/watch?v=WUICbOOtAic)
