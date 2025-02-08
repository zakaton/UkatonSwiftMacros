import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

let testMacros: [String: Macro.Type] = [
    "EnumName": EnumName.self,
    "Singleton": Singleton.self,
    "StaticLogger": StaticLogger.self
]
#endif

final class UkatonMacrosTests: XCTestCase {
    func testEnumNameMacro() {
        assertMacroExpansion("""

        @EnumName
        enum Genre {
            case horror, horrors
            case comedy
            case kids
            case action
        }


        """, expandedSource: """

        enum Genre {
            case horror, horrors
            case comedy
            case kids
            case action

            var name: String {
                switch self {
                    case .action:
                        return "Action"
                    case .comedy:
                        return "Comedy"
                    case .kids:
                        return "Kids"
                    case .horror:
                        return "Horror"
                    case .horrors:
                        return "Horrors"
                }
            }
        }
        """, macros: testMacros)
    }

    func testSingleton() {
        assertMacroExpansion("""
        @Singleton(isMutable: true)
        class MyStruct {
        }
        """, expandedSource: """
        class MyStruct {

            private init() {
            }

            static var shared = MyStruct()
        }
        """, macros: testMacros)
    }

    func testStaticLogger() {
        assertMacroExpansion("""
        import OSLog

        @StaticLogger()
        class MyStruct {
        }
        """, expandedSource: """
        import OSLog
        class MyStruct {

            static let logger: Logger? = .init(subsystem: Bundle.main.bundleIdentifier ?? "", category: "MyStruct")
            var logger: Logger? { Self.logger }
        }
        """, macros: testMacros)
    }
}
