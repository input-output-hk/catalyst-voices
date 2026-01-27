# Contributing to Catalyst Voices

First off, thanks for taking the time to contribute! ❤️

* [Contributing to Catalyst Voices](#contributing-to-catalyst-voices)
    * [Code of Conduct](#code-of-conduct)
    * [I Have a Question](#i-have-a-question)
    * [I Want To Contribute](#i-want-to-contribute)
        * [Reporting Bugs](#reporting-bugs)
            * [Before Submitting a Bug Report](#before-submitting-a-bug-report)
            * [How Do I Submit a Good Bug Report?](#how-do-i-submit-a-good-bug-report)
        * [Suggesting Enhancements](#suggesting-enhancements)
            * [Before Submitting an Enhancement](#before-submitting-an-enhancement)
            * [How Do I Submit a Good Enhancement Suggestion?](#how-do-i-submit-a-good-enhancement-suggestion)
        * [Your First Code Contribution](#your-first-code-contribution)
        * [Improving The Documentation](#improving-the-documentation)
    * [Style guides](#style-guides)
        * [Rust](#rust)
        * [Dart](#dart)
        * [Flutter](#flutter)
        * [Commit Messages](#commit-messages)

All types of contributions are encouraged and valued.
Please make sure to read the relevant section before making your contribution.
It will make it a lot easier for us maintainers and smooth out the experience for all involved.
The community looks forward to your contributions. 🎉

## Code of Conduct

This project and everyone participating in it is governed by the
[Catalyst voices Code of Conduct](https://github.com/input-output-hk/catalyst-voices/blob/main/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code.
Please report unacceptable behavior
to <code-of-conduct@iohk.io>.

## I Have a Question

> If you want to ask a question, we assume that you have read the available
[Documentation](https://input-output-hk.github.io/catalyst-voices/).

Before you ask a question, it is best to search for existing
[Issues](https://github.com/input-output-hk/catalyst-voices/issues)
that might help you.
In case you have found a suitable issue and still need clarification, you can write your question
in [GitHub Discussions](https://github.com/input-output-hk/catalyst-voices/discussions).
It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

* Open an [Issue](https://github.com/input-output-hk/catalyst-voices/issues/new/choose).
* Provide as much context as you can about what you're running into.
* Provide project and platform versions (`rustc --version --verbose`, `flutter doctor -v`, etc),
depending on what seems relevant.

We will then take care of the issue as soon as possible.

## I Want To Contribute

### Reporting Bugs

#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information.
Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report.
Please complete the following steps in advance to help us fix any potential bug as fast as possible.

* Make sure that you are using the latest version.
* Determine if your bug is really a bug and not an error on your side.
  e.g. using incompatible environment components/versions (Make sure that you have read the
  [documentation](https://input-output-hk.github.io/catalyst-voices).
  If you are looking for support, you might want to check [this section](#i-have-a-question).
* To see if other users have experienced (and potentially already solved) the same issue you are having.
  Check if there is not already a bug report existing for your bug or error in the
[bug tracker](https://github.com/input-output-hk/catalyst-voices/issues?q=is%3Aopen+is%3Aissue+label%3Abug).
* Also make sure to search the internet (including Stack Overflow)
  to see if users outside the GitHub community have discussed the issue.
* Collect information about the bug:
    * Stack trace (Traceback)
    * OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
    * Version of the interpreter, compiler, SDK, runtime environment, package manager, depending on what seems relevant.
    * Possibly your input and the output
    * Can you reliably reproduce the issue?
    And can you also reproduce it with older versions?

#### How Do I Submit a Good Bug Report?

> You must never report security related issues,
> vulnerabilities or bugs including sensitive information to the issue tracker,
> or elsewhere in public.
> Instead sensitive bugs must be sent by email to <security@iohk.io>.

We use GitHub issues to track bugs and errors.
If you run into an issue with the project:

* Open an [Issue](https://github.com/input-output-hk/catalyst-voices/issues/new).
  (Since we can't be sure at this point whether it is a bug or not,
  we ask you not to talk about a bug yet and not to label the issue.)
* Explain the behavior you would expect and the actual behavior.
* Please provide as much context as possible.
  Describe the *reproduction steps* that someone else can follow to recreate the issue on their own.
  This usually includes your code.
  For good bug reports you should isolate the problem and create a reduced test case.
* Provide the information you collected in the previous section.

Once it's filed:

* The project team will label the issue accordingly.
* A team member will try to reproduce the issue with your provided steps.
  If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps.
  The issue would then be marked as `needs-repro`.
  Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
* If the team is able to reproduce the issue, it will be marked `bug`.
  It may possibly be marked with other tags (such as `critical`).
  The issue will then be left to be [implemented by someone](#your-first-code-contribution).

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Catalyst voices,
**including completely new features and minor improvements to existing functionality**.
Following these guidelines will help maintainers and the community to understand your suggestion and
find related suggestions.

#### Before Submitting an Enhancement

* Make sure that you are using the latest version.
* Read the [documentation](https://github.com/input-output-hk/catalyst-voices) carefully.
  Find out if the functionality is already covered, maybe by an individual configuration.
* Perform a [search](https://github.com/input-output-hk/catalyst-voices/issues)
to see if the enhancement has already been suggested.
  If it has, add a comment to the existing issue instead of opening a new one.
* Find out whether your idea fits with the scope and aims of the project.
  It's up to you to make a strong case to convince the project's developers of the merits of this feature.
  Keep in mind that we want features that will be useful to the majority of our users and not just a small subset.
  If you're just targeting a minority of users, consider writing an add-on/plugin library.

#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/input-output-hk/catalyst-voices/issues).

* Use a **clear and descriptive title** for the issue to identify the suggestion.
* Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
  At this point you can also tell which alternatives do not work for you.
* You may want to **include screenshots and animated GIFs**.
  This can help you demonstrate the steps or point out the part which the suggestion is related to.
  You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows,
  and [this tool](https://github.com/colinkeenan/silentcast) or
  [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful** to most Catalyst voices users.
  You may also want to point out the other projects that solved it better and which could serve as inspiration.

### Your First Code Contribution

Embarking on your first code contribution can be an exhilarating yet intimidating endeavor.
Here at Catalyst Voices, we foster a welcoming and supportive environment to ensure
that everyone can contribute to the codebase irrespective of their experience level.
Below is a step-by-step guide to making your first code contribution to our repository:

1. **Set Up Your Environment**:
   * Fork the repository to your GitHub account.
   * Clone your fork locally on your machine.
   * Set up the development environment following the instructions in the README.

2. **Pick an Issue**:
   * Browse through the open issues in the GitHub repository.
   * Pick an issue that interests you and aligns with your skills.
  Beginners might look for issues tagged as `good first issue`
   or `beginner-friendly`.

3. **Understand the Issue**:
   * Thoroughly read through the issue to understand the problem.
   * Ask clarifying questions in the issue thread if necessary.

4. **Branch Out**:
   * Create a new branch on your local machine to work on the issue.
   * It's a good practice to name your branch descriptively, e.g., `fix-button-bug.`

5. **Work on the Issue**:
   * Work on the issue in your local development environment.
   * Adhere to the coding standards and guidelines provided in the [Style guides](#style-guides) section.

6. **Test Your Changes**:
   * Ensure that your changes are well-tested.
   * Verify that your changes don't break any existing functionality.

7. **Commit Your Changes**:
   * Write a clear and concise commit message following the [Style guides](#style-guides) -> Commit Messages section guidelines.

8. **Push Your Changes**:
   * Push your changes to your fork on GitHub.

9. **Open a Pull Request**:
   * Open a pull request from your fork to the main repository.
   * Provide a detailed description of your changes, the issue it addresses,
   and any additional information that might help maintainers review your contribution.

10. **Review and Revision**:
    * Respond to any feedback from the maintainers.
    * Make necessary revisions to your code.

11. **Merge and Celebrate**:
    * Once your pull request is approved, it will be merged into the main codebase.
    * Celebrate your contribution and share it with the community!

Remember, every contributor was new at some point, and we are thrilled to welcome new members to our community.
The journey of becoming an adept open-source contributor is rewarding and educational.
Your contribution, no matter how small, can make a significant impact.
Happy coding!

### Improving The Documentation

Documentation is a cornerstone of any successful open-source project.
It aids developers in understanding the purpose, structure, and functioning of the code, making the project accessible to all,
irrespective of their level of expertise.
Our project thrives on the contributions from the community,
and improving the documentation is one of the significant ways you can contribute.

Here are some ways you could help improve our documentation:

* **Clarification**: If you find any ambiguous or unclear documentation, feel free to clarify the wording or
suggest improvements through a pull request.
* **Expansion**: If areas of the documentation are lacking in detail or missing altogether,
contributing expanded explanations or new sections is highly encouraged.
* **Correction**: Spot a mistake?
  Whether it's a spelling error, grammatical error, or incorrect information, your corrections are welcome.
* **Examples**: Adding examples to the documentation can significantly enhance utility.
  If you have examples that illustrate the use of our code, we'd love to include them.
* **Consistency**: Ensure the documentation maintains a consistent style and tone.
  Adhering to the style guidelines specified in our [Style guides](#style-guides) section is crucial.
* **Technical Accuracy**: Ensure that the documentation reflects the current state of the codebase and is technically accurate.

Your contributions should follow the guidelines specified in our [Style guides](#style-guides)
section to maintain high quality and consistency.
Before making a substantial change, it's a good practice to open an issue to discuss the proposed changes or
find an existing issue to work on.

Together, we can ensure that our documentation is a valuable resource for all new and experienced developers.

## Style guides

### Rust

For Rust, we follow the
[Rust Style Guide](https://input-output-hk.github.io/catalyst-core/main/06_rust_api/rust_style_guide.html).

### Dart

For Dart, we follow the
[Effective Dart](https://github.com/input-output-hk/catalyst-engineering/blob/main/style_guides/dart_style_guide.md) style guide.

### Flutter

For Flutter, we follow the
[Flutter Style Guide](https://github.com/input-output-hk/catalyst-engineering/blob/main/style_guides/flutter_style_guide.md).

### Commit Messages

Clear and consistent commit messages are crucial for maintaining a readable history in our collaborative environment.
Adhering to a structured commit message format also enables us to generate changelogs and
navigate through the project's history more efficiently.
We follow the [Conventional Commits](https://www.conventionalcommits.org) standard for all commit messages in this repository.

Here's a brief overview of the Conventional Commits standard:

1. **Type**: The type of change being made (e.g., feat, fix, chore, docs, style, refactor, perf, test).
2. **Scope (Optional)**: The scope of the change, denoting what part of the codebase is being altered.
3. **Description**: A short, descriptive message of the change, written in the imperative mood.

Format:

```txt
<type>(<scope>): <description>
```

Example:

```txt
feat(button): add a 'submit' button to form component
fix(modal): resolve issue with modal overlay not closing
chore(tests): update unit tests for utilities module
```

* **Breaking Changes**: If your commit introduces a breaking change, it should be flagged with a `!` after the type.
Include `BREAKING CHANGE:` in the body or footer of the commit message to describe what changed and its implications.

Example:

```txt
feat!(dropdown): change the behavior of dropdown component
BREAKING CHANGE: alters dropdown trigger to be activated on hover instead of on click.
```

* **Footer (Optional)**: Any additional metadata regarding your commit, such as related issue trackers or
BREAKING CHANGE annotations.

Following this format makes the version control history readable and reflects professionalism and
foresight in maintaining a clean, well-documented codebase.
