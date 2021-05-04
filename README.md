# WriteMe

*Generate Markdown reference documentation from metadata using JavaScript.*

```coffeescript
import { compile } from "@dashkite/writeme"
import YAML from "js-yaml"

assert /^# Push/.test marked compile YAML.load """
  name: push
  type: function
  description: Push an item onto the stack.
  signatures:
  - arguments:
    - name: stack
			type: Stack
			description: A stack.
    - name: item
      description: The item to push onto the stack.
    returns:
      name: stack
      type: Stack
      description: A new stack with _item_ pushed onto it.
"""
```

Generates a document that will render to HTML something like this:

> # Push
>
> *Function*
>
> `push stack, item → stack`
>
> | name    | type        | description                            |
> | ------- | ----------- | -------------------------------------- |
> | stack   | [`Stack`][] | A stack.                               |
> | item    | any         | The item to push onto the stack.       |
> | → stack | [`Stack`][] | A new stack with _item_ pushed onto it |
>
> Push an item onto the stack.

Links are resolved using an optional index. You can generate an index using `index`, optionally passing it an index to update.

```coffeescript
import { index } from "@dashkite/writeme"
import YAML from "js-yaml"

assert (index name: "foo", "./foo.md")["foo"] == "./foo.md"
```

## Features

- Functions
- Classes: coming soon
- Methods: coming soon

## Install

```shell
npm i -D @dashkite/writeme
```


## Reference

### API

#### compile

`compile yaml → markdown`

Compiles the given YAML specification into Markdown.

### Schema

#### Function

Coming soon.

#### Class

Coming soon.

#### Method

Coming soon.