_ = require 'lodash'

'use strict'

class IbexPicker
  constructor: (@schema, @map) ->
  pick: (value) -> [@map value]

class IbexException
  constructor: (@message) ->

Ibex = (schema) -> (value) ->
  if (_.isPlainObject schema) && (_.isArray value)
    xs = _.map value, Ibex(schema)
    _.reduce xs, (acc, x) ->
      { valid: acc.valid && x.valid, picked: acc.picked.concat x.picked }

  else if schema instanceof IbexPicker && (_.isArray value)
    sub = (Ibex(schema.schema))(value)
    subs = _.reduce value, ((acc, x) -> acc.concat(schema.pick x)), []
    { valid: sub.valid, picked: subs.concat sub.picked }

  else if (_.isArray schema) && (_.isArray value)
    zipped = _.zipWith schema, value, (x, y) -> (Ibex(x))(y)
    _.reduce zipped, (acc, x) ->
      { valid: acc.valid && x.valid, picked: acc.picked.concat x.picked }

  else if _.isArray value
    _.reduce value, (acc, x) ->
      { valid: acc.valid && (schema == x), picked: acc.picked.concat x.picked }

  else if schema instanceof IbexPicker
    sub = (Ibex(schema.schema))(value)
    { valid: sub.valid, picked: schema.pick(value).concat sub.picked }

  else if (_.isPlainObject schema) && (_.isPlainObject value)
    xs = _.map (_.keys schema), (key) ->
      if _.has(value, key)
        (Ibex(schema[key]))(value[key])
      else
        { valid: false, picked: [] }
    _.reduce xs, (acc, x) ->
      valid: acc.valid && x.valid
      picked: acc.picked.concat x.picked

  else
    { valid: schema == value, picked: [] }

Ibex.pick = (value) -> new IbexPicker value, @map
Ibex.map = (value) -> value

module.exports = Ibex
