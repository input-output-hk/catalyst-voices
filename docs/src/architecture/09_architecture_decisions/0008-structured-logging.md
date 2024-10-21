---
    title: 0008 Structured Logging
    adr:
        author: Steven Johnson
        created: 17-Oct-2024
        status:  proposed
    tags:
        - logging
---

<!-- cspell: words Sematext,Stackify -->

## Context

Both Backend and Frontend components of Catalyst Voices produce log messages.
These log message help in development, but also in fault-finding in production.

Structured logging is a way of logging which separates the log text message from the data pertinent to the logged event.

## Assumptions

That both the Frontend and Backend are using logging libraries capable of structured logging.

## Decision

* We will use structured logging for all log messages that are to be sent to a log collection system.
* We will not use string formatting within structured log messages, but embed all data within fields in the log message.
* All log levels *MUST* use structured logging.
  * It is possible that **DEBUG** or **TRACE** level logs can selectively be enabled in production to help investigate issues.
* Log text messages should be specific enough to identify the actual log messages when searching or summarizing logs.
  * Avoid using the same log message multiple times in the same code.
* As far as we are able, we should be consistent with field names.
  * For example, we always use "error" for error values, not "Error" or "err" or "e".
  * Fields do not need to have the same name as the variable, what is important is the field name be unambiguous and consistent.
* Logs *MUST* include the date and time of the event being logged.
  * Date and Time *MUST* always be referenced to UTC, and not Local Time.
  * Date and Time *SHOULD* be formatted according to [RFC3339] (An open formalized subset of [ISO8601]).
  * If [RFC3339] is not possible to use, then [ISO8601] format *MAY* be used instead.
* Logs *SHOULD*, if possible, include the filename, and line of the log message in the code.
* Loggers *SHOULD* be configured to automatically include log fields required for every log message.
* All logs *MUST* obfuscate a client's private information before logging.
  * A non-exhaustive list of private information includes:
    * IP Addresses
    * User-Agent Strings
    * Location Information (Longitude/Latitude)
    * Device identifiers (IMEI, MAC Address, etc.)
    * Browser Fingerprints
  * For data like this, that uniquely identifies a client or session, the obfuscation of that data should be consistent.
    * For example, `ip addresses` can be hashed and turned into a [UUID].
      * The [UUID] in this case will always be the same for an `ip address`.
      * The privacy of the client is protected because it is not easily possible to derive the `ip address` from the [UUID].
      * This gives us the ability to cluster multiple interactions from a common connection without revealing the users' identity.
      * It also allows the Logs to help provide support to a user if they supply their IP Address. (Client Directed Unmasking).
* *NEVER* log Security sensitive information either in the clear or obfuscated, such as (non-exhaustive):
  * Usernames
  * Email Addresses
  * Passwords
  * API Keys
  * Private Encryption Keys

*NOTE :* **IF AND ONLY IF** log messages are a developer convenience,
**AND** will never be collected for online diagnostic purposes,
**THEN** they do not need to follow this ADR.
*IF in doubt, use structured logging.*

### Log Levels

The Standard Abstract Log levels are defined (from the highest priority to lowest) as:

* **CRITICAL** *(Optional)* - When a system has completely failed.
  * **ERROR** can also be used for this.
* **ERROR** - Something has failed which normally should not.
  * Does not have to be a fatal failure.
  * The Log message should clearly show if the error is fatal or unrecoverable.
    * For example, a failed DB connection is an *ERROR* but is not fatal.
    * Errors should be considered not fatal, unless they explicitly state otherwise.
* **WARNING** - Something which can happen, but normally shouldn't.
* **INFO** - Important System informational messages.
* **DEBUG** - Highest level detailed system operation logs.
* **TRACE** - Verbose and detailed system operation logs.

Individual languages may use different terms for these, and may have more or less defined levels.
Use the language's native log levels which map closest to this list.
For example, some languages do not have *CRITICAL*, we would map that level to *ERROR*.
In all such cases, use the next most appropriate level which matches closest with the above definitions.

#### Logging in Libraries

* Libraries *SHOULD NOT* use *INFO* level logs.
  * this level of log should be used only by applications or services.
* Libraries *MAY* use any other log level.

### Log Verbosity

Logs should aim to provide exactly the right amount of information, and no more.

* All **ERROR** logs should be logged in the most appropriate location.
  * **ERROR** or **WARNING** logs, *SHOULD* include enough context to identify the actual source of the error.
* Info level logs should only be used to provide ***IMPORTANT*** operational data.
  * Such as:
    * Build or configuration information.
    * The start of internal persistent services
  * **INFO** logs should not typically continuously stream as a result of normal system use.
  * API Endpoint statistics logs are an example of an exception to this guidance.
    * However, they *SHOULD* also have a method of selectively enabling/disabling these *INFO* logs.
    * The same principle *SHOULD* apply to any other regularly logged **INFO** level logs that may be required.
* **DEBUG** level logs should be assumed to be enabled selectively in production.
  * Their purpose *SHOULD* be aimed to helping to diagnose faults.
* Detailed and Verbose or Streaming Debug level logs should be at **TRACE** level.

### Example of Unstructured Logging to avoid

An example of unstructured logging in rust, which is not to be used:

```rust
    error!("Hello {name} An error occurred in {thing}, doing {something:?}: {err}");
```

The problems this example exhibits are:

1. This is difficult to process with automation.
2. It would need to be searched with a regex.
3. The fixed words probably appear in similar patterns in other log messages, making it difficult to discern what the log is about.
4. It may be easy for a developer to read.
However, it is not easy to read when there are tens of thousands of logs from multiple instances of a service.

### Example of Structured Logging to utilize

Instead, we should use:

```rust
    error!(name=name, thing=%thing, something=?something, error=?err, "An error occurred processing named updates to the database");
```

* Each piece of dynamic data is a field, including the string representation of the error.
* The message explains what the error is and helps locate the log both in the log messages itself, and in the code.

## Risks

The only risk relates to not doing structured logging.
It will make the system harder to manage for Operations and Support staff.

***ALWAYS REMEMBER:
Log messages are intended to be primarily read by operations and support staff.
Do not assume they know how the code works, just because you might.
Attempt to make log messages helpful to the people who will work with the system.***

## Consequences

Structured logging makes searching, summarizing and parsing log messages significantly easier.
Without it, log messages quickly become difficult to use, which defeats the purpose of generating them.

## More Information

* [Sematext: What is structured logging](https://sematext.com/glossary/structured-logging/)
* [Stackify: What Is Structured Logging and Why Developers Need It](https://stackify.com/what-is-structured-logging-and-why-developers-need-it/)

[RFC3339]: <https://www.rfc-editor.org/rfc/rfc3339>
[ISO8601]: <https://www.iso.org/iso-8601-date-and-time-format.html>
[UUID]: <https://www.rfc-editor.org/rfc/rfc9562.html>
