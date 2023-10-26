/// A macro that adds a "name" property to enums
@attached(member, names: named(name))
public macro EnumName() = #externalMacro(module: "Macros", type: "EnumName")

/// A macro that adds a singleton to a class
@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")
