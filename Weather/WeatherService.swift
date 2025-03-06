import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let name: String
}

struct Main: Codable {
    let temp: Double
}

class WeatherService {
    private let apiKey = "d1595dbde38c5113596589f1528e4299" // Replace with your OpenWeatherMap API Key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let decoder = JSONDecoder()
            let weather = try? decoder.decode(WeatherResponse.self, from: data)
            DispatchQueue.main.async { completion(weather) }
        }.resume()
    }
}

