# coffeelint-no-operation-expression
CoffeeLint rule that finds instances where there's some code that doesn't do anything.
This could mean a variable, string, or number on a line with no assignment or calls happening to it.

Ex: Any of these statements on a line by itself:
```js
5
```
```js
'stuff'
```
```js
obj
```
By themselves, they don't do anything at all. They're likely a development oversight
The chai variables "expect", "assert", and "should" bypass this rule
  since they have \_\_getter\_\_ magic happening in them.

## Installation
```sh
npm install coffeelint-no-operation-expression
```
## Usage

Add the following configuration to coffeelint.json:

```json
"no_operation_expression": {
  "module": "coffeelint-no-operation-expression"
}
```
## Configuration

There are currently no configuration options.
