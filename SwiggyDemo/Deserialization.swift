//
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation

public protocol JSONDeserializable {

  init(dictionary: [String : AnyObject])
}

// MARK: - Helper Methods

private func dataStringToObject(dataString: String) -> AnyObject? {
  guard let data: NSData = dataString.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
  var jsonObject: AnyObject?
  do {
    jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  } catch {}
  return jsonObject
}

// MARK: - Basic Deserialization

public func <-- <D: JSONDeserializable, T>(inout lhs: D?, rhs: T?) -> D? {
  let cleanedValue = convertToNilIfNull(rhs)

  if let jsonObject = cleanedValue as? NSDictionary as? [String : AnyObject] {
    lhs = D(dictionary: jsonObject)
  } else if let string = cleanedValue as? String {
    lhs <-- dataStringToObject(string)
  } else {
    lhs = nil
  }
  
  return lhs
}

public func <-- <D: JSONDeserializable, T>(inout lhs: D, rhs: T?) -> D {
  var newValue: D?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

// MARK: - Array Deserialization

public func <-- <D: JSONDeserializable, T>(inout lhs: [D]?, rhs: [T]?) -> [D]? {
  guard let rhs = rhs else { return nil }

  lhs = [D]()
  for element in rhs {
    var convertedElement: D?
    convertedElement <-- element

    if let convertedElement = convertedElement {
      lhs?.append(convertedElement)
    }
  }
  
  return lhs
}

public func <-- <D: JSONDeserializable, T>(inout lhs: [D], rhs: [T]?) -> [D] {
  var newValue: [D]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

public func <-- <D: JSONDeserializable, T>(inout lhs: [D]?, rhs: T?) -> [D]? {
  guard let rhs = rhs else { return nil }

  if let elements = rhs as? NSArray as? [AnyObject] {
    return lhs <-- elements
  }

  return nil
}

public func <-- <D: JSONDeserializable, T>(inout lhs: [D], rhs: T?) -> [D] {
  var newValue: [D]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

// MARK: - Dictionary Deserialization

public func <-- <T, D: JSONDeserializable, U>(inout lhs: [T : D]?, rhs: [T : U]?) -> [T : D]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  lhs = [T : D]()
  for (key, value) in rhs {
    var convertedValue: D?
    convertedValue <-- value

    if let convertedValue = convertedValue {
      lhs?[key] = convertedValue
    }
  }

  return lhs
}

public func <-- <T, D: JSONDeserializable, U>(inout lhs: [T : D], rhs: [T : U]?) -> [T : D] {
  var newValue: [T : D]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}

public func <-- <T, D: JSONDeserializable, U>(inout lhs: [T : D]?, rhs: U?) -> [T : D]? {
  guard let rhs = rhs else {
    lhs = nil
    return lhs
  }

  if let elements = rhs as? [T : AnyObject] {
    return lhs <-- elements
  }

  return nil
}

public func <-- <T, D: JSONDeserializable, U>(inout lhs: [T : D], rhs: U?) -> [T : D] {
  var newValue: [T : D]?
  newValue <-- rhs
  lhs = newValue ?? lhs
  return lhs
}
