---
    title: 0010 Frontend JSON Schema Constraints
    adr:
        author: Dominik Toton
        created: 14-Apr-2025
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

* The app will add it's own custom logic on top of the JSON Schema document template whenever the
 app needs cannot be satisfied by the standard set of JSON Schema features encoded within the template.
* The app will create a naming system for JSON Schema properties referred to as `nodes` that will
 assign each `node` a `nodeId` consisting of the format: `{parent.nodeId}.{propertyName}` where
 for the root node the `{parent.nodeId}` is skipped.
* The app will maintain a set of predefined `nodeIds` for which a custom app logic is added on top of JSON Schema.

### App custom logic

<!-- markdownlint-disable max-one-sentence-per-line -->
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
<!-- markdownlint-enable max-one-sentence-per-line -->

## Schema Evolution Guidelines

To safely evolve the schema over time while preserving functionality:

1. **Never rename predefined `nodeId`s** - If structure needs to change, keep the old nodeId as an alias
2. **Use versioning** - Include schema version in document metadata
3. **Add new fields rather than changing existing ones** - Mark old fields as deprecated
4. **Test template changes** - Automated testing should verify that all predefined nodeIds are still accessible

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Template modifications break nodeId lookups | UI shows placeholders instead of actual content | Create automated tests that verify all required nodeIds exist in template updates |
| Schema grows too complex with custom logic | Maintenance burden increases | Document all custom behaviors and create a clear process for adding new ones |
| Template authors don't understand constraints | Templates created that don't work with the app | Create a template authoring guide with clear examples and validation tools |
| Performance degrades with complex schemas | App becomes slow when rendering large documents | Implement performance testing for templates and optimize lookup algorithms |

## Testing Strategy

To ensure the integrity of our approach:

1. **Unit Tests** - Verify nodeId resolution logic works correctly.
2. **Integration Tests** - Check that UI components correctly display data from schema nodes.
3. **Schema Validation** - Create validators that check for required nodeIds in templates.
4. **Migration Tests** - Verify that document migrations preserve required fields.
5. **Error Handling Tests** - Verify that the system gracefully handles missing or malformed nodes.
6. **Performance Tests** (*Optional*) - Measure rendering time with different schema complexities.

## Maintenance Plan

### Current Issues

The frontend team currently spends an excessive amount of time reviewing schema change PRs from architects
who often make changes without validating against frontend constraints.
This creates an unsustainable workflow where:

1. Contributors create schema changes without understanding frontend requirements
2. PRs reach review stage with fundamental issues that break nodeId lookups
3. Frontend team must thoroughly review every schema change
4. Cycles of revisions delay implementation and waste development resources

### Improved Process

To address these issues, we suggest implementing the following improved maintenance process:

#### Automated Validation

* **CI/CD Integration**: Add an automated check in the CI pipeline that fails PRs with breaking schema changes
* **Schema Validator Tool** (*Optional*): Develop a command-line tool that validates schema changes against nodeId requirements
* **Pre-commit Hook** (*Optional*): Provide a pre-commit hook that architects can install to validate locally before pushing

#### Schema Change Workflow

1. **Intent Documentation**: Architects must document intended schema changes in a standardized format.
2. **Pre-validation**: Before creating a PR, contributors must run the validation tool against their changes.
3. **Breaking Change Protocol**: If a breaking change is necessary, architects must:
   * Document the breaking change
   * Provide a migration path
   * Coordinate with the frontend team before submission
4. **Automated Tests**: Add test cases for each predefined nodeId that verify it still works after schema changes

#### Clear Responsibilities

* **Schema Owners**: Designate specific team members as "schema owners" who understand both architectural and frontend requirements.
* **Review Rotation**: Establish a rotation of frontend developers responsible for schema reviews to distribute the burden.
* **Knowledge Transfer**: Conduct regular knowledge sharing sessions on schema constraints for architects.
* **Documentation**: Create a living document that clearly outlines all nodeId constraints with examples of what would break them.

## Consequences

* Prevents erroneous app behavior however requires a careful editing to make sure `nodeIds` of the
 predefined properties are stable.
* Predefining the properties reduces the flexibility to adjust the templates.
* Provides a clear structure for engineers to understand how to work with templates.
* Enables powerful UI capabilities that go beyond standard form rendering.
* Adds implementation complexity and maintenance overhead for custom logic.
* Requires thorough documentation and knowledge sharing across teams.

## Diagrams

### NodeId Resolution Flow

```txt
+----------------+      +-----------------+      +----------------+
| JSON Schema    | ---> | NodeId Resolver | ---> | UI Component   |
| Document       |      | {Maps path to   |      | {Renders based |
|                |      |  nodeId}        |      |  on node type} |
+----------------+      +-----------------+      +----------------+
                                |
                                v
                        +---------------+
                        | Custom Logic  |
                        | {Based on     |
                        |  nodeId}      |
                        +---------------+
```

### Document Processing Pipeline

```txt
+----------------+      +----------------+      +----------------+
| Parse Schema   | ---> | Apply Custom   | ---> | Generate UI    |
| {Validate      |      | Logic          |      | {Render forms, |
|  structure}    |      | {Based on      |      |  views based   |
|                |      |  nodeIds}      |      |  on context}   |
+----------------+      +----------------+      +----------------+
```

## More Information

* [JSON Schema Draft-07](https://json-schema.org/draft-07)
* [JSON Schema Validation](https://json-schema.org/draft-07/json-schema-validation.html)
* [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12/release-notes) - Latest standard for reference
* [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/)
* [JSON Schema for Humans](https://github.com/coveooss/json-schema-for-humans)
* [JSON Schema Validator](https://www.jsonschemavalidator.net/)
* [Another JSON Validator](https://www.npmjs.com/package/ajv-cli)
* [Visualize JSON into interactive graphs](https://jsoncrack.com/)
