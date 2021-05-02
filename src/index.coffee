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

normalize = (reference) ->
  reference.toLowerCase().replace /[^\w\s]/g, ""

compile = (description, index = {}) ->
  md = templates[ description.type ] denormalize description
  if ! _.isEmpty index
    references = []
    # first, normalize the references
    md = md.replace /\[([^\]]+)]\[([^\]]*)\]/gm, (matches, text, reference) ->
      reference = normalize if reference == "" then text else reference
      references.push reference
      "[#{text}][#{reference}]"
    # now append the links if necessary
    for reference in references
      if !(///^\[#{reference}\]:///m.test md)
        if index[reference]?
          md += "\n[#{reference}]: #{index[reference]}"
        else
          console.warn "writeme: no link for for '#{reference}'"
          md += "\n[#{reference}]: #"
  md

export {
  compile
}
