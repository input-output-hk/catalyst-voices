<!--
Based on: https://books.google.it/books?id=vHlTOVTKHeUC&hl=it&source=gbs_navlinks_s
          https://testing.googleblog.com/2016/06/the-inquiry-method-for-test-planning.html
          https://testing.googleblog.com/2011/09/10-minute-test-plan.html
-->

# [Flutter Cardano Integration](https://github.com/input-output-hk/catalyst-voices/issues/481)

* [General informations](#general-informations)
  * [Abstract](#abstract)
  * [Stakeholders](#stakeholders)
  * [Requirements](#requirements)
  * [Tools](#tools)
* [ACC framework](#acc-framework)
  * [Attributes](#attributes)
  * [Components](#components)
  * [Capabilities](#capabilities)
* [Integration tests](#integration-tests)
  * [Integration tests strategy](#integration-tests-strategy)
  * [Integration test cases](#integration-test-cases)


## General Informations

### Abstract

> :memo: **Note:** Describe the design and architecture of the system in a way that highlights possible points of failure

### Stakeholders

| Role/Name       | Contact        | Approval       |
|-----------------|----------------|----------------|
| *Eng-Manager*   |     Sasha      |                |
| *Developers*    |     Dominik    |                |
| *Testers*       |     Duy        |                |

### Requirements

[EPIC](https://github.com/input-output-hk/catalyst-voices/issues/399)  
[CIP-30](https://cips.cardano.org/cip/CIP-30)  
[CIP-95](https://cips.cardano.org/cip/CIP-95)  
Testing will be focused only on web applications for the time being.  
Focus needs to be on compliance with CIP-30 and CIP-95 specs, reliability and security especially when handling wallet interactions and message signing. UI testing is out of scope, the web application will be used only for setup purpose.  

### Acceptance criteria

-[] The package must comply with CIP-30 and CIP-95 specifications, focusing on the web.  
-[] High unit test coverage to ensure reliability and security.  
-[] Clear and comprehensive documentation for developers.  
-[] An example web application that effectively demonstrates the package's functionalities.  

### Risks

Documentation is not complete yet, integration dart package might be not enough  

### Tools

The main tool we will use is dart integration test package. We still need to investigate if all the testing needed can be archived only with dart or if we need to use playwright for the web UI part  

## ACC framework

> :memo: **Note:** Use the [ACC framework](https://testing.googleblog.com/2011/09/10-minute-test-plan.html)
> to help you define the test cases

### Attributes

Secure, complaint with CIP 30 and 36, reliable    

### Components

Web application  

### Capabilities

User can retrieve his wallet details  
User can sign data  
User can sign transactions  
User submit transactions  

## Integration tests

### Integration tests strategy

> :memo: **Note:** Evaluate all integrations with other functions, services etc.

### Integration test cases

| \#  | OBJECTIVE | STEPS | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   | User can retrieve his wallet details |  Start application, Download wallet chrome extention, Connect wallet extention in the application  | The application and the api will show the correct wallet details | YES  |
| 2   | User can sign data | Connect the wallet as #1, click sign data,
