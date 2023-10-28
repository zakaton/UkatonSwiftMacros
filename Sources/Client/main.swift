import OSLog
import UkatonMacros

@EnumName
enum FlightTicket {
    case economy
    case business
    case firstClass
}

@EnumName
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

@Singleton
@StaticLogger
class MyStruct {}
