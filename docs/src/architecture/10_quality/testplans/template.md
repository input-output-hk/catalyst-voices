<!--
Based on: https://books.google.it/books?id=vHlTOVTKHeUC&hl=it&source=gbs_navlinks_s
          https://testing.googleblog.com/2016/06/the-inquiry-method-for-test-planning.html
          https://testing.googleblog.com/2011/09/10-minute-test-plan.html
-->

*This is meant to be only a guideline, the paragraphs can be removed or added as they fit*

# [Test Plan Template](https://github.com/input-output-hk/catalyst-voices/issues/1)
*insert test plan name and link to the github testplan issue*

- [General informations](#general-informations)
  - [Abstract](#abstract)
  - [Stakeholders](#stakeholders)
  - [Requirements](#requirements)
  - [Tools](#tools)
- [ACC framework](#acc-framework)
  - [Attributes](#attributes)
  - [Components](#components)
  - [Capabilities](#capabilities)
- [Unit tests](#unit-tests)
  - [Unit test strategy](#unit-test-strategy)
  - [Unit test cases](#unit-test-cases)
- [Feature tests](#feature-tests)
  - [Feature test strategy](#feature-tests-strategy)
  - [Feature test cases](#feature-test-cases)
- [Regression tests](#regression-tests)
  - [Regression test strategy](#regression-tests-strategy)
  - [Regression test cases](#regression-test-cases)
- [Integration tests](#integration-tests)
  - [Integration test strategy](#integration-tests-strategy)
  - [Integration test cases](#integration-test-cases)
- [End-to-end tests](#end-to-end-tests)
  - [End-to-end test strategy](#end-to-end-tests-strategy)
  - [End-to-end test cases](#end-to-end-test-cases)


## General Informations

### Abstract
*Describe the design and architecture of the system in a way that highlights possible points of failure*

### Stakeholders
*Insert the relevant stakeholders that needs to understand review and approve the test plan*

| Role/Name   | Contact        | Approval |
|-------------|----------------|----------------|
| *Product-Owner* |  |  |
| *Developers* |  |  |
| *Admin* |  |  |
| *SRE* |  |  |
| *Testers* |  |  |


### Requirements
*Business requirements, insert links to relevant Github or JIRA tickets, list what platforms are supported, what will not be tested etc*

### Tools
*Describe what tools will be needed for the testing, if new tools are needed to be developed*

## ACC framework
*Use the [ACC framework](https://testing.googleblog.com/2011/09/10-minute-test-plan.html) to help you define the testcases*

### Attributes
*The adverbs and adjectives that describe the high level concepts testing is meant to ensure. Attributes such as fast, usable, secure, accessible and so forth. The quality metrics document in this repo should and can be used as a guideline*

### Components
*The nouns that define the major code chunks that comprise the product. These are classes, module names and features of the application.*

### Capabilities
*The verbs that describe user actions and activities.*

## Unit tests

### Unit tests strategy

*Evaluate new features and bug fixes introduced in this release, and the extent of the unit tests*

### Unit test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## Regression tests

*Ensure that previously developed and tested software still performs after change.*

### Regression tests strategy

*Evaluate all reports introduced in previous releases*

### Regression test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## Integration tests

*Combine individual software modules and test as a group.*

### Integration tests strategy

*Evaluate all integrations with locally developed shared libraries, with consumed services, and other touch points.*

### Integration test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## End-to-end tests

*Verify that the solution works for the user*

### End-to-end tests strategy

*For end-to-end testing, how will test infrastructure, systems under test, and other dependencies be managed? How will they be deployed? How will persistence be set-up/torn-down? How will you handle required migrations from one datacenter to another?*

### End-to-end test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |