import {print, test, success} from "amen"
import {wrap, flow, tee} from "@pandastrike/garden"
import * as k from "@dashkite/katana"
import faker from "faker"
import * as m from "@dashkite/mimic"

verifySuccess = tee flow [
  m.defined "bora-messages"
  m.waitFor "bora-messages"
  m.shadow
  # waitFor <selector> assumes page scope
  m.screenshot path: "./screenshot.png"
  m.waitFor (root) -> root.querySelector ".success"
]

export default ([server, browser]) ->
  {port} = server.address()
  displayName = faker.name.findName()
  nickname = displayName.replace /\W/g, ""
  print await test "Bora Web Client",  [

    await test description: "Scenario: create", wait: 5000, flow [
      wrap [ {browser} ]
      m.page
      m.goto "http://localhost:#{port}/create"
      tee flow [
        m.defined "bora-create"
        m.select "bora-create"
        m.shadow
        m.select "input[name='nickname']"
        m.type nickname
        # TODO test fails here because we never submit the form
        #      attempting to explicitly submit triggers a nav event
        #      clicking the button disables the button but not the
        #      input, so something is wrong there as well
        #      -
        #      this test failing is also causing the next test to fail
        m.press "Enter"
      ]
      verifySuccess
    ]

    await test description: "Scenario: set display name", wait: 5000, flow [
      wrap [ {browser} ]
      m.page
      m.goto "http://localhost:#{port}/update/page"
      m.defined "bora-update"
      m.waitFor "bora-update"
      m.shadow
      # can't waitFor form to render b/c it doesn't work w/in shadow DOM
      m.pause
      m.select "input[name='displayName']"
      m.type displayName
      m.press "Enter"
      verifySuccess
    ]
  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
