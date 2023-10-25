import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum EnumInitError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "This macro can only be applied to a enum."
        }
    }
}

public struct EnumNameMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        // this macro can only be assigned to enums
        guard let enumDel = declaration.as(EnumDeclSyntax.self) else {
            throw EnumInitError.onlyApplicableToEnum
        }
        
        let members = enumDel.memberBlock.members
        let caseDecl = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let cases = caseDecl.compactMap {
            $0.elements.first?.name.text
        }
        
        var name = """
        var name: String {
            switch self {
        """
        
        for nameCase in cases {
            name += "case .\(nameCase):"
            name += "return \"\(nameCase.capitalized)\""
        }
        
        name += """
            }
        }
        """
        
        return [DeclSyntax(stringLiteral: name)]
    }
}

@main
struct UkatonSwiftMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumNameMacro.self,
    ]
}
