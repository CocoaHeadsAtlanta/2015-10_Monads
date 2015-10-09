//: Playground - noun: a place where people can play

import UIKit

typealias Numberify = Int -> Int

func theMultiplier(number: Int) -> Numberify
{
    return { input in
        return input * number
    }
}

let hundreder = theMultiplier(100)

hundreder(3)
hundreder(42)
hundreder(-8)

enum OptionalString {
    case Some(String)
    case None
}

let thingy1 = OptionalString.Some("Hello World")
let thingy2 = OptionalString.None

switch thingy2 { // change out with thingy1
    
case let .Some(myString):
    print("\(myString)")
    
case .None:
    print("There isn't a string in there")
}

let thingy3 = Optional<String>.Some("Hello World")
let thingy4 = Optional<String>.None

switch thingy4 { // change out with thingy3
    
case let .Some(myString):
    print("\(myString)")
    
case .None:
    print("There isn’t a string in there")
}

func ifStringThenMaybeInteger(maybeString: Optional<String>, block: (String) -> Optional<Int>) -> Optional<Int>
{
    switch maybeString {
        
    case let .Some(myString):
        return block(myString)
        
    case .None:
        return nil
        
    }
}

let result1 = ifStringThenMaybeInteger(thingy3) { aString in
    return 42
}

let result2 = ifStringThenMaybeInteger(thingy4) { aString in
    return 42
}


func ifSomethingDoAThing<T, U>(maybe: T?, block: T -> U?) -> U?
{
    if let value = maybe {
        return block(value)
    }
    else {
        return nil
    }
}

let thingy5 = Optional("42")

let doAThingResult = ifSomethingDoAThing(thingy5) { aString -> Optional<Int> in
    return Int(aString)
}

let flatMapResult = thingy5.flatMap { aString in
    return Int(aString)
}.flatMap { anInt in
    return "The answer to everything is \(anInt)"
}

