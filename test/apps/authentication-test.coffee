express = require 'express'
assert  = require 'assert'
request = require 'request'
app     = require '../../app'

describe "authentication", ->
  describe "GET /login", ->
    body = null
    before (done) ->
      options = 
        uri: "http://localhost:#{app.get('port')}/login"
      request options, (err, res, _body) ->
        body = _body
        done()
    it "has title", ->
      assert.hasTag body, '//head/title', 'Hot Pie - Login'
    it "has user field", ->
      assert.hasTag body, '//input[@name="user"]', ''
    it "has password field", ->
      assert.hasTag body, '//input[@name="password"]', ''

  describe "POST /sessions", ->
    describe "incorrect credentials", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri:"http://localhost:#{app.get('port')}/sessions"
          form:
            user: 'incorrect user'
            password: 'incorrect password'
          followAllRedirects: false
        request.post options, (ignoreErr, postResponse, postResponseBody) ->
          request.get 'http:'+postResponse.headers.location, (err, _response, _body) ->
            [body, response] = [_body, _response]
            done()
      it "shows flash message", ->
        errorText = 'Those credentials were incorrect. Try again.'
        assert.hasTag body, "//p[@class='flash error']", errorText

    describe "correct credentials", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri:"http://localhost:#{app.get('port')}/sessions"
          form:
            user: 'piechef'
            password: '12345'
          followAllRedirects: false
        request.post options, (ignoreErr, postResponse, postResponseBody) ->
          request.get 'http:'+postResponse.headers.location, (err, _response, _body) ->
            [body, response] = [_body, _response]
            done()
      it "shows flash message", ->
        errorText = 'You are now logged in as piechef.'
        assert.hasTag body, "//p[@class='flash info']", errorText

  describe "DELETE /sessions", ->
    [body, response] = [null, null]
    before (done) ->
      options =
        uri:"http://localhost:#{app.get('port')}/sessions"
        followAllRedirects: true
      request.del options, (err, _response, _body) ->
        [body, response] = [_body, _response]
        done()
    it "shows flash message", ->
      errorText = 'You have been logged out.'
      assert.hasTag body, "//p[@class='flash info']", errorText