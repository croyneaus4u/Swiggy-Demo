//
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation

func convertToNilIfNull<T>(value: T?) -> T? {
    return (value is NSNull) ? nil : value
}

/// Operator for use in right hand side to left hand side conversion.
infix operator <-- { associativity right precedence 150 }

/// Thrown when a conversion operation fails.
public enum JSONConversionError: ErrorType {
  
  case UnsupportedType
  case InvalidValue
}

/// An object that can attempt to convert values of unknown types to its own type.
public protocol JSONConvertible {

  static func convertFromValue<T>(value: T?) throws -> Self?
}

// MARK: - Basic Conversion

public func <-- <T, U>(inout lhs: T?, rhs: U?) -> T? {
  if !(lhs is NSNull) {
    lhs = convertToNilIfNull(rhs) as? T
  } else {
    lhs = rhs as? T
  }
  return lhs
}

public func <-- <T, U>(inout lhs: T, rhs: U?) -> T {
  var newValue: T?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

public func <-- <C: JSONConvertible, T>(inout lhs: C?, rhs: T?) -> C? {
  lhs = nil

  do {
    lhs = try C.convertFromValue(convertToNilIfNull(rhs))
  } catch JSONConversionError.InvalidValue {
#if DEBUG
    print("Invalid value \(rhs.debugDescription) for supported type.")
#endif
  } catch JSONConversionError.UnsupportedType {
#if DEBUG
    print("Unsupported type.")
#endif
  } catch {}

  return lhs
}

public func <-- <C: JSONConvertible, T>(inout lhs: C, rhs: T?) -> C {
  var newValue: C?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

// MARK: - Array Conversion

public func <-- <C: JSONConvertible, T>(inout lhs: [C]?, rhs: [T]?) -> [C]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  lhs = [C]()
  for element in rhs {
    var convertedElement: C?
    convertedElement <-- element

    if let convertedElement = convertedElement {
      lhs?.append(convertedElement)
    }
  }

  return lhs
}

public func <-- <C: JSONConvertible, T>(inout lhs: [C], rhs: [T]?) -> [C] {
  var newValue: [C]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

public func <-- <C: JSONConvertible, T>(inout lhs: [C]?, rhs: T?) -> [C]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  if let elements = rhs as? NSArray as? [AnyObject] {
    return lhs <-- elements
  }

  return nil
}

public func <-- <C: JSONConvertible, T>(inout lhs: [C], rhs: T?) -> [C] {
  var newValue: [C]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

// MARK: - Dictionary Conversion

public func <-- <T, C: JSONConvertible, U>(inout lhs: [T : C]?, rhs: [T : U]?) -> [T : C]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  lhs = [T : C]()
  for (key, value) in rhs {
    var convertedValue: C?
    convertedValue <-- value
    if let convertedValue = convertedValue {
      lhs?[key] = convertedValue
    }
  }

  return lhs
}

public func <-- <T, C: JSONConvertible, U>(inout lhs: [T : C], rhs: [T : U]?) -> [T : C] {
  var newValue: [T : C]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

public func <-- <T, C: JSONConvertible, U>(inout lhs: [T : C]?, rhs: U?) -> [T : C]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  if let elements = rhs as? [T : AnyObject] {
    return lhs <-- elements
  }

  return nil
}

public func <-- <T, C: JSONConvertible, U>(inout lhs: [T : C], rhs: U?) -> [T : C] {
  var newValue: [T : C]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

// MARK: - Enum Conversion

public func <-- <T: RawRepresentable, U>(inout lhs: T?, rhs: U?) -> T? {
  var newValue: T?

  if let
    rawValue = rhs as? T.RawValue,
    enumValue = T(rawValue: rawValue) {
    newValue = enumValue
  }
  lhs = newValue

  return lhs
}

public func <-- <T: RawRepresentable, U>(inout lhs: T, rhs: U?) -> T {
  var newValue: T?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}
