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

@Singleton
@StaticLogger
class MyStruct {}
