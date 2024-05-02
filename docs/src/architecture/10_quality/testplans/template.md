<!--
Based on: https://books.google.it/books?id=vHlTOVTKHeUC&hl=it&source=gbs_navlinks_s
          https://testing.googleblog.com/2016/06/the-inquiry-method-for-test-planning.html
          https://testing.googleblog.com/2011/09/10-minute-test-plan.html
-->

# [Test Plan <insert test plan name and link to the github testplan issue>](https://github.com/input-output-hk/catalyst-voices/issues/1)

- [INFORMATIONS](#informations)
  - [STAKEHOLDERS](#stakeholders)
  - [ABSTRACT](#abstract)
- [UNIT TESTS](#unit-test)
  - [UNIT TEST STRATEGY](#unit-test-strategy)
  - [UNIT TEST CASES](#unit-test-cases)
- [REGRESSION TESTS](#regression-test-section)
  - [REGRESSION TEST STRATEGY](#regression-test-strategy)
  - [REGRESSION TEST CASES](#regression-test-cases)
- [INTEGRATION TESTS](#integration-test-section)
  - [INTEGRATION TEST STRATEGY](#integration-test-strategy)
  - [INTEGRATION TEST CASES](#integration-test-cases)
- [USER ACCEPTANCE TESTS](#user-acceptance-test-section)
  - [USER ACCEPTANCE TEST STRATEGY](#user-acceptance-test-strategy)
  - [USER ACCEPTANCE TEST CASES](#user-acceptance-test-cases)


## INFORMATIONS

### STAKEHOLDERS

<Insert the relevant parties that need to review and approve the test plan>

| Role/Name   | Contact        | Approval |
|-------------|----------------|----------------|
| *Product-Owner* |  |  |
| *Developers* |  |  |
| *Admin* |  |  |
| *SRE* |  |  |
| *Testers* |  |  |


### ABSTRACT

<Description of the feature, features or release to test>

### REQUIREMENTS

<Business requirements, possibly insert links to relevant Github or JIRA tickets >

### RISKS
### TOOLS
### COVERAGE
### PROCESS

### ATTRIBUTES
````diff
+ the adverbs and adjectives that describe the high level concepts testing is meant to ensure. Attributes such as fast, usable, secure, accessible and so forth.

### COMPONENTS
the nouns that define the major code chunks that comprise the product. These are classes, module names and features of the application.
### CAPABILITIES
the verbs that describe user actions and activities.

## UNIT TESTS

### UNIT TEST STRATEGY

<Evaluate new features and bug fixes introduced in this release, and the extent of the unit tests>

### UNIT TEST CASES

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --- | --------- | ----- | ---------------- | ----------------- |
| 1   |           |       |                  |                   |

## REGRESSION TESTS

<Ensure that previously developed and tested software still performs after change.>

### REGRESSION TEST STRATEGY

<Evaluate all reports introduced in previous releases>

### REGRESSION TEST CASES

| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | OBSERVED |
| --- | --------- | ----- | ---------------- | -------- |
| 1   |           |       |                  |          |

## INTEGRATION TEST

Combine individual software modules and test as a group.

### INTEGRATION TEST STRATEGY

Evaluate all integrations with locally developed shared libraries, with consumed services, and other touch points.

### INTEGRATION TEST CASES

| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --- | --------- | ----- | ---------------- | ----------------- |
| 1   |           |       |                  |                   |

## USER ACCEPTANCE TEST

Verify that the solution works for the user

### USER ACCEPTANCE TEST STRATEGY

{Explain how user acceptance testing will be accomplished}

### USER ACCEPTANCE TEST CASES

| #   | TEST ITEM | EXPECTED RESULTS | ACTUAL RESULTS | DATE |
| --- | --------- | ---------------- | -------------- | ---- |
| 1   |           |                  |                |      |
