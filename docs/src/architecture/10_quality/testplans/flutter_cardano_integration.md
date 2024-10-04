<!--
Based on: https://books.google.it/books?id=vHlTOVTKHeUC&hl=it&source=gbs_navlinks_s
          https://testing.googleblog.com/2016/06/the-inquiry-method-for-test-planning.html
          https://testing.googleblog.com/2011/09/10-minute-test-plan.html
-->

# [Flutter Cardano Integration](https://github.com/input-output-hk/catalyst-voices/issues/546)

* [Flutter Cardano Integration](#flutter-cardano-integration)
  * [General Informations](#general-informations)
    * [Abstract](#abstract)
    * [Stakeholders](#stakeholders)
    * [Requirements](#requirements)
    * [Acceptance criteria](#acceptance-criteria)
    * [Risks](#risks)
    * [Tools](#tools)
  * [ACC framework](#acc-framework)
    * [Attributes](#attributes)
    * [Components](#components)
    * [Capabilities](#capabilities)
  * [Integration tests](#integration-tests)
    * [Integration tests strategy](#integration-tests-strategy)
    * [Integration test cases](#integration-test-cases)
  * [Extensions](#extensions)
  * [User actions](#user-actions)
  * [Wallet](#wallet)

## General Informations

### Abstract

Catalyst Cardano is a web application that facilitate interaction with the Cardano blockchain.
It incorporates CIP-30 (Wallet DAppBridge) and CIP-95 (Message Signing) specifications.
It requires connection to the wallet third party extensions (e.g Eternl) to be able to perform wallet actions.
These actions are namely retrieving wallet details, signing data/transactions and submiting transactions.

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
Focus needs to be on compliance with CIP-30 and CIP-95 specs, reliability and security.
This is especially needed when handling wallet interactions and message signing.
UI testing is out of scope, the web application will be used only for setup purpose.

### Acceptance criteria

* The package must comply with CIP-30 and CIP-95 specifications, focusing on the web.
* High unit test coverage to ensure reliability and security.
* Clear and comprehensive documentation for developers.
* An example web application that effectively demonstrates the package's functionalities.
* The web application needs to support Lace, Nami, Eternl, and Vespr

### Risks

Documentation is not complete yet, integration dart package might be not enough

### Tools

The main tool we will use is Playwright

## ACC framework

> :memo: **Note:** Use the [ACC framework](https://testing.googleblog.com/2011/09/10-minute-test-plan.html)
> to help you define the test cases

### Attributes

Secure, comply with CIP-30 and CIP-95, reliable

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

## Extensions

| \#  | OBJECTIVE | STEPS | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   | Wallet extension installation success |  Start application, Download wallet chrome extension  | Displays message when Wallet extension is successfully installed | YES  |
| 2   | Wallet extension installation failure |  Start application, Download wallet chrome extension  | Displays error message handling when Wallet extension installation fails | YES  |
| 3   | Wallet extension detection |  Start application, Download wallet chrome extension | Displays message when the app correctly detects the presence of the Wallet extension | YES  |

## User actions

| \#  | OBJECTIVE | STEPS | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   | User can retrieve his wallet details |  Start application, Download wallet chrome extension, Connect wallet extension in the application, Enable wallet  | Wallet details (balance, addresses, etc.) is correctly returned | YES  |
| 2   | User can sign data | Connect the wallet as #1, sign data | No exceptions are thrown, VkeyWitness is valid | YES |
| 3   | User can sign transactions | Connect the wallet as #1, sign transaction data | No exceptions are thrown, and in TransactionWitnessSet, atleast one VkeyWitness is present | YES |
| 4   | User can submit transactions | Connect the wallet as #1, submit transaction | No exceptions are thrown, Returned TransactionHash is not empty, Metadata is not included| YES |
| 5   | User can handle invalid transactions | Connect the wallet as #1, create and submit an invalid transaction (e.g., incorrect signature, insufficient funds, malformed data) | Appropriate error message is returned, Transaction is not processed | YES |
| 6   | User can submit transactions with metadata | Connect the wallet as #1, submit transaction with metadata | No exceptions are thrown, Returned TransactionHash is not empty, transaction is processed successfully with metadata | YES |
| 7   | User can submit transactions with auxiliary data set | Connect the wallet as #1, create and submit transaction with auxiliary data set, verify auxiliary_data_set existence | If auxiliary_data_set exists, process the transaction successfully, otherwise return None | YES |

## Wallet

| \#  | OBJECTIVE | STEPS | EXPECTED RESULTS | TO BE AUTOMATED |
| --- | --------- | ----- | ---------------- | --------------- |
| 1   | Empty wallet list |  Start application, Download wallet chrome extension, Connect wallet extension in the application  | Displays empty message when no wallets are available | YES  |
| 2   | Wallet enabling success |  Start application, Download wallet chrome extension, Connect wallet extension in the application, Enable wallet  | Displays message is displayed when enabling wallet success | YES  |
| 3  | Wallet enabling failure |  Start application, Download wallet chrome extension, Connect wallet extension in the application, Enable wallet  | Error message is displayed when enabling wallet fails | YES  |
| 4   | Error while loading wallet details |  Connect the wallet as #1  | Error message is displayed when loading wallet details fails | YES  |
| 5   | Sign data failure |  Connect the wallet as #1, sign data  | Error message is displayed when signing data fails | YES  |
| 6   | Sign and submit transaction failure |  Connect the wallet as #1, sign data, submit data  | Error message is displayed when signing and submitting transaction fails | YES  |
