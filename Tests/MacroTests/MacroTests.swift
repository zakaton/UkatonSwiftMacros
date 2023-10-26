import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

let testMacros: [String: Macro.Type] = [
    "EnumName": EnumNameMacro.self
]
#endif

final class UkatonMacrosTests: XCTestCase {
    func testEnumNameMacro() {
        assertMacroExpansion("""

        @EnumName
        enum Genre {
            case horror
            case comedy
            case kids
            case action
        }


        """, expandedSource: """

            @EnumName
            enum Genre {
                case horror
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
                    }
                }
            }
        """, macros: testMacros)
    }
}
