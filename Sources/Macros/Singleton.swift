// https://github.com/ShenghaiWang/SwiftMacros/blob/main/Sources/Macros/Singleton.swift

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Singleton: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
        Context: MacroExpansionContext>(of node: AttributeSyntax,
                                        providingMembersOf declaration: Declaration,
                                        in context: Context) throws -> [DeclSyntax]
    {
        guard [SwiftSyntax.SyntaxKind.classDecl, .structDecl].contains(declaration.kind) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a struct or class")
        }
        let identifier = (declaration as? StructDeclSyntax)?.name ?? (declaration as? ClassDeclSyntax)?.name ?? ""
        var override = ""
        if let inheritedTypes = (declaration as? ClassDeclSyntax)?.inheritanceClause?.inheritedTypes,
           inheritedTypes.contains(where: { inherited in inherited.type.trimmedDescription == "NSObject" })
        {
            override = "override "
        }

        let initializer = try InitializerDeclSyntax("private \(raw: override)init()") {}

        let selfToken: TokenSyntax = "\(raw: identifier.text)()"
        let initShared = FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: selfToken)) {}
        let sharedInitializer = InitializerClauseSyntax(equal: .equalToken(trailingTrivia: .space),
                                                        value: initShared)

        let staticToken: TokenSyntax = "static"
        let staticModifier = DeclModifierSyntax(name: staticToken)
        var modifiers = DeclModifierListSyntax([staticModifier])

        let isPublicACL = declaration.modifiers.compactMap(\.name.tokenKind.keyword).contains(.public)
        if isPublicACL {
            let publicToken: TokenSyntax = "public"
            let publicModifier = DeclModifierSyntax(name: publicToken)
            // modifiers = modifiers.inserting(publicModifier, at: 0)
            modifiers = .init(itemsBuilder: {
                publicModifier
                modifiers
            })
        }

        let isMutableString: String? = if case let .argumentList(arguments) = node.arguments {
            Array(arguments)
                .first(where: { $0.label?.text == "isMutable" })?
                .expression
                .as(BooleanLiteralExprSyntax.self)?
                .literal
                .text

        } else {
            nil
        }

        let isMutable = Bool(isMutableString ?? "false") ?? false

        let shared = VariableDeclSyntax(modifiers: modifiers,
                                        isMutable ? .var : .let, name: "shared",
                                        initializer: sharedInitializer)

        return [DeclSyntax(initializer),
                DeclSyntax(shared)]
    }
}

extension TokenKind {
    var keyword: Keyword? {
        switch self {
        case let .keyword(keyword): return keyword
        default: return nil
        }
    }
}
