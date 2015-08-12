Ibex = require '../js'

describe 'Ibex', ->
  it 'should verify equal primitive values', ->
    expect((Ibex "foo") "foo").toEqual { valid: true, picked: [] }
    expect((Ibex 2.0) 2.0).toEqual { valid: true, picked: [] }

  it 'should pick equal primitive values', ->
    expect((Ibex (Ibex.pick "foo")) "foo")
      .toEqual {valid: true, picked: ["foo"] }
    expect((Ibex (Ibex.pick 2.0)) 2.0)
      .toEqual { valid: true, picked: [2.0] }

  it 'should verify simple object', ->
    valid_person = Ibex
      name: "Foo"
      age: 20
    barbara =
      name: "Foo"
      age: 20
      old: yes
    expect(valid_person barbara)
      .toEqual { valid: true, picked:[] }

  it 'should pick simple object', ->
    name_age = Ibex
      name: Ibex.pick "Foo"
      age: Ibex.pick 20
    barbara =
      name: "Foo"
      age: 20
      old: yes
    expect(name_age barbara).toEqual { valid: true, picked:["Foo", 20] }

  it 'should pick from list of values', ->
    one_two_three = Ibex [(Ibex.pick 1), 2, 3]
    expect(one_two_three [1,2,3]).toEqual { valid: true, picked:[1] }

  it 'should verify list of values', ->
    namepick = Ibex
      name: Ibex.pick "F"
    barbara =
      name: "F"
      age: 20
      old: yes
    barbaras = [barbara, barbara, barbara]
    expect(namepick barbaras).toEqual { valid: true, picked:["F","F","F"] }
