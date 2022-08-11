//
//  Inject.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation

// MARK: - @propertyWrapper Inject

/// This property wrappers allows us to resolve the Dependency being requested
@propertyWrapper
public struct Inject<Value> {
  
  // MARK: - Properties
  
  private(set) public var wrappedValue: Value
  
  // MARK: - Init
  /**
   This property wrappers allows us to resolve the Dependency being requested
   - Parameters:
      - container: (default: DependencyContainer.shared) the container to resolve dependencies from
      - key: (default: nil) the string key to request a dependency for
      - mode: (default: .shared) the mode to request the dependency as
   */
  public init(container: DIContainer = DependencyContainer.shared, key: String? = nil, mode: ResolveMode = .shared) {
    if let key = key {
      wrappedValue = container.resolve(key: key, mode: mode)
    } else {
      wrappedValue = container.resolve(type: Value.self, mode: mode)
    }
  }
}
