import OSLog
import UkatonMacros

@EnumName
enum FlightTicket {
    case economy
    case business
    case firstClass
}

@EnumName(accessLevel: "public")
enum Genre {
    case horror
    case comedy
    case kids
    case action
}

@EnumName
enum WifiInformation {
    case getSsid, setSsid
}

@Singleton(isMutable: true)
@StaticLogger
class MyStruct {}
