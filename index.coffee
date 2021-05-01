import "coffeescript/register"
import p from "path"
import * as t from "@dashkite/genie"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"
import * as q from "panda-quill"
import YAML from "js-yaml"
import Handlebars from "handlebars"
import {tee, flow} from "@pandastrike/garden"

t.define "clean", -> m.rm "build"

t.define "build", "clean", m.start [
  m.glob [ "{src,test}/**/*.coffee" ], "."
  m.read
  flow [
    m.tr coffee "node"
    m.extension ".js"
    m.write p.join "build", "node"
  ]
  flow [
    m.tr coffee "import"
    m.extension ".js"
    m.write p.join "build", "import"
  ]
]

t.define "node:test", [ "build" ], ->
  m.exec "node", [
    "--enable-source-maps"
    "./build/node/test/index.js"
  ]

t.define "test", [ "clean" ], ->
  require "../test"

Handlebars.registerHelper "lower", (text) ->
  text = Handlebars.escapeExpression text
  new Handlebars.SafeString text.toLowerCase()

t.define "docs:generate", ->
  reference = YAML.load await q.read p.join "docs", "reference.yaml"
  template = Handlebars.compile await q.read p.join "docs", "reference.md.hbs"
  q.write (p.join "docs", "reference.md"), template reference
