import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"

import { sleep } from "@dashkite/joy/time"
import { trim } from "@dashkite/joy/text"

import { File } from "#resources/file"

# TODO read from configuration...
configuration =
  base: "https://box-d0qd6vjjkhzh5w98more9h2t8.dashkite.run/"

do ->

  window.__test = await do ->

    test "In-Browser Tests", [

      test "Basic File Editing", [

        await test
          description: "Create a file"
          wait: false
          ->
            await File.put
              base: configuration.base
              path: "edit-test/foo.md"
              content: "This is a test"
              headers: "content-type": "text/markdown"

        await test
          description: "Get created file"
          wait: false
          ->
            await sleep 1000
            assert.equal "This is a test",
              await File.get
                base: configuration.base
                path: "edit-test/foo.md"
                headers: "accept": "text/markdown"

        await test
          description: "Update a file"
          wait: false
          ->
            await File.put
              base: configuration.base
              path: "edit-test/foo.md"
              content: "This is another test"
              headers: "content-type": "text/markdown"

            # we should have to wait more than 1 second
            # to see the update ...
            await sleep 1000

            assert.equal "This is another test",
              await File.get
                base: configuration.base
                path: "edit-test/foo.md"
                headers: "accept": "text/markdown"

        await test
          description: "JIT build based on content negotiation"
          wait: false
          ->
            assert.equal "<p>This is another test</p>",
              trim await File.get
                base: configuration.base
                path: "edit-test/foo.md"
                headers: "accept": "text/html"


        test
          description: "Delete file"
          wait: false
          ->
            await File.delete
              base: configuration.base
              path: "edit-test/foo.md"

      ]


    ]
