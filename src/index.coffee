import fs from "fs"
import path from "path"
import handlebars from "handlebars"
import * as _ from "@dashkite/joy"

# TODO
# - class methods
# - class and instance properties
# - how to handle interfaces?
#   - punt for now?
# - initial release
#   - experiment with joy?
#   - too ambitious? mercury? masonry?

template = do ({code, source} = {})->
  (name) ->
    source = path.join __dirname, "templates", "#{name}.hbs"
    code = fs.readFileSync source, "utf8"
    handlebars.compile code, srcName: source

templates =
  function: template "function"
  type: template "type"
  method: template "method"

denormalize = do ({
  example
  language
  code
  labels
} = {}) ->
  _.tee (description) ->
    if description.examples?
      for example in description.examples
        labels = ! _.isEmpty _.keys example.code
        for language, code of example.code
          example.code[language] =
            code: code
            language: _.toLowerCase language
            label: if labels then language

compile = (description, index = {}) ->

  templates[ description.type ] denormalize description

export {
  compile
}
