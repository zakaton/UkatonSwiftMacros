/// A macro that adds a "name" property to enums
@attached(member, names: named(name))
public macro EnumName() = #externalMacro(module: "UkatonMacrosMacros", type: "EnumNameMacro")
