import "coffeescript/register"
import p from "path"
import * as _ from "@dashkite/joy"
import * as t from "@dashkite/genie"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"

t.define "clean", -> m.rm "build"

t.define "templates", m.start [
  m.glob [ "{src,test}/**/*.hbs" ], "."
  m.copy p.join "build", "import"
  m.copy p.join "build", "node"
]

t.define "markdown", m.start [
  m.glob [ "test/**/*.md" ], "."
  m.copy p.join "build", "import"
  m.copy p.join "build", "node"
]

t.define "build", [ "clean", "templates", "markdown" ], m.start [
  m.glob [ "{src,test}/**/*.coffee" ], "."
  m.read
  _.flow [
    m.tr coffee target: "node"
    m.extension ".js"
    m.write p.join "build", "node"
  ]
  _.flow [
    m.tr coffee target: "import"
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
