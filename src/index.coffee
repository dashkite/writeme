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

addSymbol = (symbols, symbol) ->
  if symbols[ symbol.name ]? && ! _.equal symbols[ symbol.name ], symbol
    console.warn "writeme: conflicting symbol definitions
      for #{symbol.name}"
  else
    symbols[ symbol.name ] = symbol
  symbols

denormalize = do ({
  example
  language
  code
  labels
} = {}) ->
  _.tee (description) ->

    description.title ?= description.name

    if description.type == "method" && description.receiver?
      description.symbols = {}
      description.receiver =
        name: _.dashes description.receiver
        type: description.receiver
        description: "An instance of #{description.receiver}"
      addSymbol description.symbols, description.receiver

    if description.signatures?
      description.symbols ?= {}
      for signature in description.signatures
        if signature.arguments?
          for argument in signature.arguments
            addSymbol description.symbols, argument
        returns = {signature.returns...}
        if returns.name?
          returns.name = "&rarr; #{returns.name}"
        addSymbol description.symbols, returns

    if description.example?

      for section in description.example.sections
        versions = []
        labels = ! _.isEmpty _.keys section.code
        for language, code of section.code
          versions.push
            code: code
            language: _.toLowerCase language
            label: if labels then language

        section.code = versions

normalize = (reference) ->
  reference.replace /[^\w\s:.]/g, ""

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
