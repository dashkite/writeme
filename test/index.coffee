import assert from "assert"
import {print, test, success} from "amen"
# import marked from "marked"
import YAML from "js-yaml"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import * as $ from "../src/"

import * as x from "../src"

do ->

  print await test "WriteMe", [

    test "generate an index", ->

    test "generate markdown files", ->

      await m.rm "test/docs/reference"

      build = m.start [
        m.glob [ "**/*.yaml" ], "./test/spec"
        m.read
        _.flow [
          m.tr ({input}) ->
            $.compile (YAML.load input),
              stack: "/types/stack"
          m.extension ".md"
          m.write "test/docs/reference"
        ]
      ]

      await build()

  ]

  process.exit if success then 0 else 1
