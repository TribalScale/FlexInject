//
//  DependencyContainer.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation

// MARK: - DependencyContainer

public final class DependencyContainer {

  // MARK: - Properties
  
  /// The globally shared dependency container.
  public static let shared: DIContainer = DependencyContainer()
  /// Holding a copy of how the dependency is resolved such that if we need to create a new instance we can.
  private var dependencyInitializer: [String: () -> Any] = [:]
  /// Holding a copy of the resolved dependency so that we can share it anywhere a new one isn't needed
  private var dependencyShared: [String: Any] = [:]
  
  // MARK: - Init
  
  /// Public initializer if you want to make your own container to use instead of using the shared.
  public init () { }
}

// MARK: - <DIContainer>

extension DependencyContainer: DIContainer {

  // MARK: - Register
  
  /**
   Register a dependency based on it's type
   - Parameters:
    - type: The type for the dependency to add to the container
    - dependency: The closure used to create the dependency
   */
  public func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType) {
    register(key: dependencyKey(for: type), dependency: dependency)
  }

  /**
   Register a dependency based on a key
   - Parameters:
    - key: The key for the dependency to add to the container
    - dependency: The closure used to create the dependency
   */
  public func register<DependencyType>(key: String, dependency: @escaping () -> DependencyType) {
    dependencyInitializer[key] = dependency
  }
  
  // MARK: - Resolve
  /**
   Finds our dependency based on the type registered
   - Parameters:
    - type: The type of dependency to retreive from the container
    - mode: The ResolveMode to get the dependency based on
   - Important: This method will crash if no dependency is available
   - Returns: The dependency for the given type
   */
  public func resolve<DependencyType>(type: DependencyType.Type, mode: ResolveMode = .shared) -> DependencyType {
    return resolve(key: dependencyKey(for: type), mode: mode)
  }

  /**
   Finds our dependency based on the type registered
   - Parameters:
    - key: The key for the dependency to retreive from the container
    - mode: The ResolveMode to get the dependency based on
   - Important: This method will crash if no dependency is available
   - Returns: The dependency for the given key
   */
  public func resolve<DependencyType>(key: String, mode: ResolveMode = .shared) -> DependencyType {
    switch mode {
    case .new:
      guard let newDependency = dependencyInitializer[key]?() as? DependencyType else {
        preconditionFailure("DependencyContainer.resolve. There is no dependency registered for this type. Please register a dependency for this type.")
      }
      
      return newDependency

    case .shared:
      if dependencyShared[key] == nil, let dependency = dependencyInitializer[key]?() {
        dependencyShared[key] = dependency
      }

      guard let sharedDependency = dependencyShared[key] as? DependencyType else {
        preconditionFailure("DependencyContainer.resolve. There is no dependency registered for this type. Please register a dependency for this type.")
      }

      return sharedDependency
    }
  }
  
  // MARK: - Remove
  
  /**
   Remove a given dependency from the container based on it's type
   
   - Parameters:
      - type: The type to remove from the dependency container
   */
  public func remove<DependencyType>(type: DependencyType.Type) {
    remove(key: dependencyKey(for: type))
  }
  
  /**
   Remove a given dependency from the container based on it's key
   
   - Parameters:
      - key: The key to remove from the dependency container
   */
  public func remove(key: String) {
    dependencyInitializer.removeValue(forKey: key)
    dependencyShared.removeValue(forKey: key)
  }
  
  /**
   Remove all the dependencies from the container
   */
  public func removeAll() {
    dependencyInitializer = [:]
    dependencyShared = [:]
  }
  
  // MARK: - Helpers
  /**
   Generate the key to use in the dictionary for registering and resolving dependencies by type
   
   - Parameters:
    - type: The type to use to generate to a string key
   
   - Returns: String representation of the type
   */
  private func dependencyKey<DependencyType>(for type: DependencyType.Type) -> String {
    return String(describing: type)
  }
}
