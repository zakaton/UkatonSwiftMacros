/// A macro that adds a "name" property to enums
/// - Parameters:
///   - accessLevel: An optional access level
@attached(member, names: named(name))
public macro EnumName(
    accessLevel: String? = nil
) = #externalMacro(module: "Macros", type: "EnumName")

/// A macro that adds a singleton to a class
/// - Parameters:
///   - isMutable: make shared value "var" or "let"
@attached(member, names: named(init), named(shared))
public macro Singleton(
    isMutable: Bool = false
) = #externalMacro(module: "Macros", type: "Singleton")

/// Adds a static `logger` member to the type.
/// - Parameters:
///   - subsystem: An optional subsystem for the logger to use. Defaults to `Bundle.main.bundleIdentifier`.
///   - category: An optional category for the logger to use. Defaults to `String(describing: Self.self)`.
@attached(member, names: named(logger))
public macro StaticLogger(
    subsystem: String? = nil,
    category: String? = nil
) = #externalMacro(module: "Macros", type: "StaticLogger")
