//
//  LazyInject.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation

// MARK: - @propertyWrapper LazyInject

/// This property wrappers allows us to resolve the Dependency being requested using a lazy variable
@propertyWrapper
public struct LazyInject<Value> {
  
  // MARK: - Properties
  
  /// The container to look into for the dependency requested
  private let container: DIContainer
  /// The key to look in the DIContainer for
  private let key: String?
  /// The mode to resolve that dependency as
  private let mode: ResolveMode
  /// The value that the dependency is then resolved to.
  /// Making this property lazy allows for circular references
  private(set) public lazy var wrappedValue: Value = {
    if let key = self.key {
      return self.container.resolve(key: key, mode: self.mode)
    } else {
      return self.container.resolve(type: Value.self, mode: self.mode)
    }
  }()
  
  // MARK: - Init
  /**
   This property wrappers allows us to resolve the Dependency being requested using a lazy variable
   - Parameters:
      - container: (default: DependencyContainer.shared) the container to resolve dependencies from
      - key: (default: nil) the string key to request a dependency for
      - mode: (default: .shared) the mode to request the dependency as
   */
  public init(container: DIContainer = DependencyContainer.shared, key: String? = nil, mode: ResolveMode = .shared) {
    self.container = container
    self.key = key
    self.mode = mode
  }
}
