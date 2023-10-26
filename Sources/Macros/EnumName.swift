// https://github.com/azamsharp/EnumTitleMacro/blob/main/Sources/SharpMacros/SharpMacro.swift#L39

import Foundation
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

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return $0 + " " + String($1).lowercased()
                }
            }
            return $0 + String($1)
        }
    }
}

public struct EnumName: MemberMacro {
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
            name += "return \"\(nameCase.camelCaseToWords())\""
        }

        name += """
            }
        }
        """

        return [DeclSyntax(stringLiteral: name)]
    }
}
