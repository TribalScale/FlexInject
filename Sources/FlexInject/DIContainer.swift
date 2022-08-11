//
//  DIContainer.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation

// MARK: - DIContainer

/// Protocol for the definition of our dependency container
public protocol DIContainer {
  /**
   Register a dependency based on it's type
   - Parameters:
    - type: The type for the dependency to add to the container
    - dependency: The closure used to create the dependency
   */
  func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType)
  /**
   Register a dependency based on a key
   - Parameters:
    - key: The key for the dependency to add to the container
    - dependency: The closure used to create the dependency
   */
  func register<DependencyType>(key: String, dependency: @escaping () -> DependencyType)
  /**
   Finds our dependency based on the type registered
   - Parameters:
    - type: The type of dependency to retreive from the container
    - mode: The ResolveMode to get the dependency based on
   - Returns: The dependency for the given type
   */
  func resolve<DependencyType>(type: DependencyType.Type, mode: ResolveMode) -> DependencyType
  /**
   Finds our dependency based on the type registered
   - Parameters:
    - key: The key for the dependency to retreive from the container
    - mode: The ResolveMode to get the dependency based on
   - Returns: The dependency for the given key
   */
  func resolve<DependencyType>(key: String, mode: ResolveMode) -> DependencyType
  /**
   Remove a given dependency from the container based on it's type
   
   - Parameters:
      - type: The type to remove from the dependency container
   */
  func remove<DependencyType>(type: DependencyType.Type)
  /**
   Remove a given dependency from the container based on it's key
   
   - Parameters:
      - key: The key to remove from the dependency container
   */
  func remove(key: String)
  /**
   Remove all the dependencies from the container
   */
  func removeAll()
}
