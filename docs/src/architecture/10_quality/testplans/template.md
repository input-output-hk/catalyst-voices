<!--
Based on: https://books.google.it/books?id=vHlTOVTKHeUC&hl=it&source=gbs_navlinks_s
          https://testing.googleblog.com/2016/06/the-inquiry-method-for-test-planning.html
          https://testing.googleblog.com/2011/09/10-minute-test-plan.html
-->

# Test Plan Template

> :memo: **Note:** Substitute with test plan name and link to the github testplan issue.
>
# [Test Plan Name](https://github.com/input-output-hk/catalyst-voices/issues/481)

> :memo: **Note:** This is meant to be only a guideline, the paragraphs can be removed or added as they fit.

* [General informations](#general-informations)
  * [Abstract](#abstract)
  * [Stakeholders](#stakeholders)
  * [Requirements](#requirements)
  * [Tools](#tools)
* [ACC framework](#acc-framework)
  * [Attributes](#attributes)
  * [Components](#components)
  * [Capabilities](#capabilities)
* [Unit tests](#unit-tests)
  * [Unit tests strategy](#unit-tests-strategy)
  * [Unit test cases](#unit-test-cases)
* [Functional tests](#functional-tests)
  * [Functional tests strategy](#functional-tests-strategy)
  * [Functional test cases](#functional-test-cases)
* [Regression tests](#regression-tests)
  * [Regression tests strategy](#regression-tests-strategy)
  * [Regression test cases](#regression-test-cases)
* [Integration tests](#integration-tests)
  * [Integration tests strategy](#integration-tests-strategy)
  * [Integration test cases](#integration-test-cases)
* [End-to-end tests](#end-to-end-tests)
  * [End-to-end tests strategy](#end-to-end-tests-strategy)
  * [End-to-end test cases](#end-to-end-test-cases)

## General Informations

### Abstract

> :memo: **Note:** Describe the design and architecture of the system in a way that highlights possible points of failure

### Stakeholders

> :memo: **Note:** Insert the relevant stakeholders that need to understand, review and approve the test plan

| Role/Name       | Contact        | Approval       |
|-----------------|----------------|----------------|
| *Product-Owner* |                |                |
| *Developers*    |                |                |
| *Admin*         |                |                |
| *SRE*           |                |                |
| *Testers*       |                |                |

### Requirements

> :memo: **Note:** Business requirements, insert links to relevant Github or JIRA tickets,
> list what platforms are supported, what will not be tested, etc

### Tools

> :memo: **Note:** Describe what tools will be needed for the testing, if new tools are needed to be developed

## ACC framework

> :memo: **Note:** Use the [ACC framework](https://testing.googleblog.com/2011/09/10-minute-test-plan.html)
> to help you define the test cases

### Attributes

> :memo: **Note:** The adverbs and adjectives that describe the high level concepts testing is meant to ensure.
> Attributes such as fast, usable, secure, accessible and so forth.
> The quality metrics document in this repo should and can be used as a guideline

### Components

> :memo: **Note:** The nouns that define the major code chunks that comprise the product.
These are classes, module names and features of the application.

### Capabilities

> :memo: **Note:** The verbs that describe user actions and activities.
> Every capability should be testable.

## Unit tests

### Unit tests strategy

> :memo: **Note:** Evaluate new features and bug fixes introduced in this release, and the extent of the unit tests

### Unit test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## Functional tests

### Functional tests strategy

> :memo: **Note:** Evaluate new features introduced in this release, and the extent of the functional tests

### Functional test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## Regression tests

### Regression tests strategy

> :memo: **Note:** Ensure that previously developed and tested software still performs after change.

### Regression test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## Integration tests

### Integration tests strategy

> :memo: **Note:** Evaluate all integrations with other functions, services etc.

### Integration test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |

## End-to-end tests

### End-to-end tests strategy

> :memo: **Note:** Evaluate how will test infrastructure, systems under test, and other dependencies be managed?
> How will they be deployed?
> How will persistence be set-up/torn-down?
> How will you handle required migrations from one datacenter to another?

### End-to-end test cases

| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   |           |       |                  |                 |
