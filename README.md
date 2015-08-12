
# Ibex

Ibex is an embedded CoffeeScript DSL for picking object(s) from a
JSON object given a schema.

# Usage

```coffee
object =
  name: "Foo"
  husband:
    name: "Black"
    age: 20
```

How to get `"Black"` from object without the painful undefined checking?

1. Define an Ibex schema

```coffee
Ibex = require 'ibex'
husband_name = Ibex
  husband:
    name: Ibex.pick "Black"
```

2. Apply the schema to the object to get the list of retrieved values.

```coffee
husband_name object # => ["Black"]
```

# License

MIT
