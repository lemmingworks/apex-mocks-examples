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

### Stubbing
- [ApexMocks Documentation - Stubbing](https://www.joelemmer.com/apexmocks-documentation-stubbing/)

### Mocking/Verifying
- [Mocking Salesforce Apex Methods with ApexMocks Verify](https://www.joelemmer.com/mocking-salesforce-apex-methods-with-apexmocks-verify/)

### Matchers
- [ApexMocks String Matchers Cookbook](https://www.joelemmer.com/apexmocks-string-matchers-cookbook/)
- [ApexMocks Number Matchers Cookbook](https://www.joelemmer.com/apexmocks-number-matchers-cookbook/)
- [ApexMocks Date and Datetime Matchers Cookbook](https://www.joelemmer.com/apexmocks-date-and-time-matchers-cookbook/)
