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
  As we may selectively enable debug or trace level logs in production to help investigate issues.
* Log text messages should be specific enough to identify the actual log messages when searching or summarizing logs.
Don't use the same log message multiple times in the same code.
* As far as we are able, we should be consistent with field names.
For example, we always use "error" for error values, not "error" or "err" or "e".
Fields do not need to have the same name as the variable, what is important is the field name be unambiguous and consistent.
* Logs *MUST* include the date and time of the event being logged.
Date and Time *MUST* always be referenced to UTC, and not Local Time.
* Logs *SHOULD*, if possible, include the filename, and line of the log message in the code.
* It is *RECOMMENDED* that basic log information be pre-configured such that all log messages automatically include it.
* API Endpoints *MUST* obfuscate sensitive information before logging, such as IP Addresses of the client.
However, in the case of data that uniquely identifies a client or session, the obfuscation should be consistent.
  * For example, `ip addresses` can be hashed and turned into a `UUID`.
The `UUID` in this case will always be the same for an `ip address`.
However, the privacy of the client is protected because it is not easily possible to derive the `ip address` from the UUID.

*NOTE :* **IF AND ONLY IF** log messages are a developer convenience,
**AND** will never be collected for online diagnostic purposes,
**THEN** they do not need to follow this adr.
*IF in doubt, use structured logging.*

### Example of Unstructured Logging to avoid

An example of unstructured logging in rust, which is not to be used:

```rust
    error!("Hello {name} An error occurred in {thing}, doing {something:?}: {err}");
```

The problems this example exhibits are:

1. This is difficult to process.  
2. It would need to be searched with a regex.
3. The fixed words probably appear in similar patterns in other log messages, making it difficult to discern what the log is about.
4. It may be easy for a developer to read.
But, it is not easy to read when there are 10s of 1000s of messages from dozens of instances of a service.

### Example of Structured Logging to utilize

Instead, we should use:

```rust
    error!(name=name, thing=%thing, something=?something, error=?err "An error occurred processing named updates to the database.");
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
