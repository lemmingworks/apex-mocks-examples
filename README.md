# joelemmer.com ApexMocks Examples

This repo contains runnable examples for the ApexMocks mocking framework.

## How to run the examples in this repo

1. Create a scratch org using sfdx.

```bash
sfdx force:org:create -f config/project-scratch-def.json -a apexmocks-examples --setdefaultusername
```

2. Push the project metadata (in this case the Apex classes containing the code) into the scratch org.

```bash
sfdx force:source:push
```

3. Run the unit tests:
- Either from within VSCode by clicking on the *Run Test* links in test files.
- Or, from the developer console via Tests -> New Run.
- Or, using sfdx e.g. `sfdx force:apex:test:run -n "Stubbing_Test" -r human`

## Documentation and blog posts on [joelemmer.com](https://www.joelemmer.com)

### Developer Guide
- [Simplifying Apex unit test setup using mocking - a real-world example](https://www.joelemmer.com/using-mocking-in-salesforce-unit-tests)

### Stubbing
- [ApexMocks Documentation - Stubbing](https://www.joelemmer.com/apexmocks-documentation-stubbing/)

### Mocking/Verifying
- [Mocking Salesforce Apex Methods with ApexMocks Verify](https://www.joelemmer.com/mocking-salesforce-apex-methods-with-apexmocks-verify/)

### Matchers
- [ApexMocks String Matching Methods](https://www.joelemmer.com/apexmocks-string-matching-methods/)
- [ApexMocks Number Matching Methods](https://www.joelemmer.com/apexmocks-number-matching-methods/)
- [ApexMocks Date and Datetime Matching Methods](https://www.joelemmer.com/apexmocks-date-and-time-matching-methods/)
