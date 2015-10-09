footer: © Fish Hook LLC, 2015

# The M-Word: Understanding Monads
Evan DeLaney
@edelaney05

---

# Where we’re going…
- Higher-Order Functions
- Sum Types
- Monads

---

# Higher-Order Functions

^ Functions that either take functions as arguments or return a function as its result.

---

# Don’t Be Scared
```swift
class func animateWithDuration(_ duration: NSTimeInterval,
animations: () -> Void)
```

^ Right there, that “animation block” makes animationWithDuration(_:animations:) a higher order function.

 ---

# wat
```swift
func doNumberyThing(number: Int) -> Int -> Int
func doStringThing(words: String) -> String -> String
```

^ But, seriously: what? A function that takes an integer and returns a function that takes an integer that returns an integer. No, you did not just have a stroke.

---

# Let’s try that again…

```swift
typealias Numberify = Int -> Int
typealias Stringify = String -> String
func doNumberyThing(number: Int) -> Numberify
func doStringThing(words: String) -> Stringify
```

^ Using typealias can help ease you into getting your head wrapped around functions that return functions. Finding a good name for your return type can be challenging

---

# Code Time
```swift
func theMultiplier(number: Int) -> Numberify 
{
    return { input in
        return number * input
    }
}
```

---

# Code Time
```swift
let hundreder = theMultiplier(100)
hundreder(3)
hundreder(42)
hundreder(-8)
```

^ What is hundreder's data type? 

---

# Sum Types A.K.A. enums

^ Swift Enums are “Sum Types,” which is a fancy pants way of saying a type that only allows for value1 _or_ value2. Compare that to product types which allows value1 _and_ values2.

---

# Optionals are Sum Types
```swift
enum OptionalString {
    case Some(String)
    case None
}
```

^ We can either have an _Some_ or a _None_ value, and Swift gives us a way for Optional to carry along a String

---

# Code Time
```swift
let thingy1 = OptionalString.Some("Hello World")
let thingy2 = OptionalString.None

switch thingy1 {
case let .Some(myString):
    print("\(myString)")
case .None:
    print("There isn’t a string in there")
}

```

---

# Bring in the generics
```swift
enum Optional<Wrapped> {
    case Some(Wrapped)
    case None
}
```

^ Whoa! Calm down. We’ve just made our original data type, which only worked with strings, now work with basically any data type.

---

# Code Time
```swift
let thingy3 = Optional<String>.Some("Hello World")
let thingy4 = Optional<String>.None

switch thingy3 {
case let .Some(myString):
    print("\(myString)")
case .None:
    print("There isn’t a string in there")
}

```

^ This is a pretty common usage pattern for Optional. If we’ve got something, do a thing with it. If we don’t, then just keep on trucking.

---

### Are we there yet?

---

### Let’s combine the Optional type and higher-order functions

---

# If-Something-Then-Do-A-Thing
```swift
func ifStringThenMaybeInteger(maybeString: Optional<String>,
block: (String) -> Optional<Int>) -> Optional<Int>
{
    switch maybeString {
    case let .Some(myString):
        return block(myString)
    case .None:
        return nil
    }
}
```

^ We get to transform `maybeString` by using `block` if it is actually a string. You’ll notice that the block function returns an Int wrapped up in an Optional; this will be important later!

---
# Let’s Code
```swift
let result1 = ifStringThenMaybeInteger(thingy3) { aString in
    return 42
}

let result2 = ifStringThenMaybeInteger(thingy4) { aString in
    return 42
}
```

---

## This functionality is oddly specific.
### We can use generic types to make it apply to more data types

---
# Let’s Code
```swift
func ifSomethingDoAThing<T, U>(maybe: T?, block: T -> U?) -> U?
{
    switch maybe {
    case let .Some(myValue):
        return block(myValue)
    case .None
        return nil
    }
}
```

^ T and U are stand-ins for basically any data type. You can now ifSomethingDoAThing with an optional string, optional int, optional float, etc. and get a result that’s an optional string, optional int, optional puppy, etc.

---

# Let’s Code
```swift
let thingy5 = Optional("42")

let doAThingResult1 = ifSomethingDoAThing(thingy5) { aString in
    return Int(aString)
}
```

^ What is the data type of `doAThingResult`? It’s an optional Int

---
# `flatMap`

Surprise! We’ve already got an `ifSomethingDoAThing` function in Swift.

It’s a _method_ on Optional named `flatMap`

^ But, what’s cool about it being a method (instead of a free floating function) is that we can _chain_ things together

---
# Let’s Code
```swift
let flatMapResult = thingy5.flatMap { aString in
    return Int(aString)
}.flatMap { anInt in
    return "The answer to everything is \(anInt)"
}
```

---

How is it that we’re able to chain all of these if-something-do-a-thing blocks together!?

---

Because each `flatMap` always returns
an _optional_ <**whatever**>

^ Optional is always wrapping a type. `flatMap` operates on Optional, and the block operates on the what’s inside, but gives us back a wrapped result. This allows us developers to build a sequence of steps that have disparate types.

---

## Monads wrap types
### Monads are burritos - get it?

---

## Monads allow for pipelines of computation
### Monads are programmable semicolons - get it?

---

[Functional Programming in Swift](https://www.objc.io/books/fpinswift/)

[What the Heck is a Monad](http://khanlou.com/2015/09/what-the-heck-is-a-monad/)

[Efficient JSON in Swift with Functional Concepts and Generics](https://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics)

