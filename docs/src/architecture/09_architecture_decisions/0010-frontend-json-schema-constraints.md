---
    title: 0010 Frontend JSON Schema Constraints
    adr:
        author: Dominik Toton
        created: 04-Apr-2025
        status:  draft
    tags:
        - flutter
---

## Context

[JSON Schema Draft-07] is a standard chosen to describe templates for various documents with which the frontend app must work.
The responsibilities of the frontend app are to understand the JSON Schema structure and build meaningful UI components from it.
With the complexity of the JSON Schema it's important to understand the constraints that the frontend app has.

## Assumptions

* Some of the app logic needs are not encoded directly in the JSON Schema document templates
 therefore the app adds it's own logic on top of the JSON Schema logic.
* There is no immediate plan to update the JSON Schema templates to satisfy the needs of the app due to resource constraints.
* Documenting the app custom logic will help to understand how to build document templates.

## Decision

* The app will add it's own custom logic on top of the JSON Schema document template whenever
 app needs cannot be satisfied by the standard set of JSON Schema features encoded within the template.
* The app will create a naming system for JSON Schema properties referred to as `nodes` that will
 assign each `node` a `nodeId` consisting of the format: `{parent.nodeId}.{propertyName}` where
 for the root node the `{parent.nodeId}` is skipped.
* The app will maintain a set of predefined `nodeIds` for which a custom app logic is added on top of JSON Schema.

App custom logic:

| Document Type         | Node ID           | Property Type | App Needs        |
|----------------|--------------------------|---------------|------------------|
| `ProposalTemplate` | `setup.title.title` | `string` | Programmatically prefill the text in a `title` property. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `setup.title.title` | `string` | Show the proposal title in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `summary.solution.summary` | `string` | Show the proposal description in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `summary.budget.requestedFunds` | `integer` | Show the requested funds in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `summary.time.duration` | `integer` | Show the project duration in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `setup.proposer.applicant` | `string` | Show the proposal author in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `campaign_category` | `object` | App logic requires to show category information in the proposal builder but to hide it in the proposal viewer. The app needs to know which properties should not be rendered. This node and children nodes are excluded. |
| `ProposalTemplate` | `campaign_category.category_details.details` | `object` | Show selected category details in the proposal builder. When the app sees this `nodeId` it will override the standard property widget with a category widget that fetches data externally and doesn't use the template property to render itself. The template has no data about the category. The app must know which property is a category property to know where in the proposal builder to put the overridden category widget. |
| `ProposalTemplate` | `milestones.milestones` | `object` | Show the milestone count in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `milestones.milestones.milestone_list` | `array` | Show the milestone count in the UI components. The app needs to programmatically lookup in the template the related property. |
| `ProposalTemplate` | `theme.theme.grouped_tag` | `object` | Show the proposal theme in the UI components. The app needs to programmatically lookup in the template the related property. |

## Risks

* Failure to understand app constraints will cause erroneous behavior if the document template
 is modified in a way that prevents the app from looking up predefined properties.
* I.e. the UI components can start showing placeholders instead of actual titles because
the app won't be able to lookup the related property. The same is true for other properties listed above.

## Consequences

* Prevents erroneous app behavior however requires a careful editing to make sure `nodeIds` of the
 predefined properties are stable.
* Predefining the properties reduces the flexibility to adjust templates.

## More Information

* [JSON Schema Draft-07](https://json-schema.org/draft-07)
