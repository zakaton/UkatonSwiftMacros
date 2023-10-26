import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UkatonMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumName.self,
        Singleton.self,
        StaticLogger.self
    ]
}
