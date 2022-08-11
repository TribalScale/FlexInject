//
//  WeakInject.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation

// MARK: - @propertyWrapper WeakInject

/// This property wrappers allows us to resolve the Dependency being requested using a weak reference to the resolved dependency
@propertyWrapper
public struct WeakInject<Value> {
  
  // MARK: - Properties
  
  /// Variable to hold the weak reference to the resolved dependency
  private weak var underlyingValue: AnyObject?
  
  public var wrappedValue: Value? {
    return underlyingValue as? Value
  }
  
  // MARK: - Init
  
  /**
   This property wrappers allows us to resolve the Dependency being requested using a weak reference to the resolved dependency
   - Parameters:
      - container: (default: DependencyContainer.shared) the container to resolve dependencies from
      - key: (default: nil) the string key to request a dependency for
      - mode: (default: .shared) the mode to request the dependency as
   */
  public init(container: DIContainer = DependencyContainer.shared, key: String? = nil, mode: ResolveMode = .shared) {
    if let key = key {
      self.underlyingValue = container.resolve(key: key, mode: mode)
    } else {
      self.underlyingValue = container.resolve(type: Value.self, mode: mode) as AnyObject
    }
  }
}
