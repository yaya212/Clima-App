
struct WeatherData: Codable{
    let weather:[Weather]
    let main:Main
    let name:String
}

struct Weather: Codable{
    let description:String
    let id: Int
}


struct Main: Codable{
    let temp:Double
}
