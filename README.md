# OrderedSet
A static, ordered collection of unique objects.

[![macOS](https://github.com/frazer-rbsn/OrderedSet/actions/workflows/macos.yml/badge.svg)](https://github.com/frazer-rbsn/OrderedSet/actions/workflows/macos.yml)
[![Ubuntu](https://github.com/frazer-rbsn/OrderedSet/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/frazer-rbsn/OrderedSet/actions/workflows/ubuntu.yml)



## About

In short, an `OrderedSet` is an immutable hybrid of an `Array` and a `Set`. Like an `Array`, it's elements have
a defined order, but it enforces uniqueness on it's members like a `Set`. 

You can use `OrderedSet` as a drop-in replacement for an `Array` if:
 * the element type conforms to `Hashable` (e.g. `Int`, `String`, `Double` etc., or your own type),
 * you do not need to perform in-place modification of the array,
 * and all elements should occur only once.

It can give you significant performance boosts when working with large collections, over using an `Array`.

You can use `OrderedSet` as a drop-in replacement for a `Set` if:
 * you do not need to perform in-place modification of the set,
 * and you require the members of the set to have a defined order.

`OrderedSet` is implemented in pure Swift with no Objective-C constructs.  
`OrderedSet` is a *static set*, i.e. once initialised, it cannot be mutated. It is similar to `NSOrderedSet` from Objective-C Foundation.  
`OrderedSet` has no dependencies. It does not depend on `Foundation`.

## Installation

Swift Package Manager:

```swift
dependencies: [
  .package(url: "https://github.com/frazer-rbsn/OrderedSet.git", exact: "2.0.0"),
],
```


## Usage

For example, if we have a large array of strings:

```swift
let largeCollection: [String]
```

If it's important to retain the order of these strings, and we want to ensure that each string is unqiue, we can easily change this to an `OrderedSet` like this:

```swift
let largeCollection: OrderedSet<String>
```

The benefits of doing this can be seen when performing operations such as `.contains(:_)` on large collections, 
which on an `OrderedSet`, is an *O(1)* operation, as it's backed by a standard `Set`. 
On an array, this operation would be *O(n)*, as the time required to compute it is affected by the number of items in the array.


### Initialisation

An `OrderedSet` can be initialised in the following ways:

```swift
// With an array
let s = OrderedSet(["John", "Sally", "Bob", "Alice"])

// With a range
let s = OrderedSet(0..<5)
// ---> OrderedSet([0,1,2,3,4])

// With an array literal
let t : OrderedSet<String> = ["A", "B", "C"]

// With a set, sorted by a closure
let s = OrderedSet(someSet, sortedBy: { $0.name < $1.name })

// With a set, where the elements conform to Comparable
let comparableSet = Set([3,4,1,2])
let s = OrderedSet(comparableSet)
// ---> OrderedSet([1,2,3,4])
```

When initialising an `OrderedSet` with an array, by default the `OrderedSet` will retain 
the first instance of any duplicate elements:

```swift
let arr = ["Chris", "Bob", "Chris", "Alice"]
let s = OrderedSet(arr)
// ---> OrderedSet(["Chris", "Bob", "Alice"])
```

If you wish to retain the *last* occurrence of an element, use the `retainLastOccurrences` parameter and set it to `true`:

```swift
let arr = ["Chris", "Bob", "Chris", "Alice"]
let s = OrderedSet(arr, retainLastOccurrences: true)
// ---> OrderedSet(["Bob", "Chris", "Alice"])
```


### Properties

When working with an `OrderedSet`, you may need to cast it back to an `Array` or `Set` when working with an API.
`OrderedSet` provides access to it's internal storage via these properties:

* `.array`
* `.contiguousArray`
* `.unorderedSet`

### Functions

`OrderedSet` implements many of the common collection functions, such as `compactMap(:_)`, `filter(:_)` 
and `shuffled(:_)`. These will return a new `OrderedSet` instead of an array where possible. 

```swift
let s = OrderedSet(["john", "sally", "bob", "alice"])
let t = s.map { $0.capitalized }
// ---> OrderedSet(["John", "Sally", "Bob", "Alice"])
```

Because `OrderedSet` is static -- it has no operations that can modify the collection --  
it provides a few non-standard functions, such as `removingAll(:_)` 
which gives the inverse of an equivalent call to `filter(:_)`, and `appending(:_)`, 
which returns a new `OrderedSet` with the given element appended to the end.

Standard set algebra functions are available, and can be used with both other `OrderedSet` instances 
and standard `Set` collections.

```swift
let a = Set(1,2,4)
let b = OrderedSet([1,2,3,4,5])
let isSuperSet = b.isSuperset(of: a)
// ---> true
```

Unlike with an `Array`, checking the index of an element in `OrderedSet` is also an *O(1)* operation.

```swift
let s = OrderedSet(["Carol", "Bob", "Joan"])
let i = s.index(of: "Bob")
// ---> 1
```


### Conformances

* `Sendable`
* `ExpressibleByArrayLiteral`
* `RandomAccessCollection`
* `Hashable`
* `Equatable`
* `Codable` (if Element conforms to `Codable`)
* `CustomStringConvertible`

`OrderedSet` will encode to and decode from a JSON array.

```swift
struct House: Codable {
  let members: OrderedSet<String>
}

let json = """
    {
      "members": [
        "Jim",
        "Carol",
        "Joan",
        "Felix"
      ]
    }
    """
let jsonData = json.data(using: .utf8)!
let decoder = JSONDecoder()
let house = try decoder.decode(House.self, from: jsonData)
// ---> house.members -> OrderedSet(["Jim","Carol","Joan","Felix"])
```

Equality is determined in the same way as an array.

```swift
let array = [1,2,3,4,5]
let array2 = [1,3,2,4,5]
let s1 = OrderedSet(array)
let s2 = OrderedSet(array2)
let isEqual = s1 == s2
// ---> false
```

## License

MIT. See `LICENSE`.
