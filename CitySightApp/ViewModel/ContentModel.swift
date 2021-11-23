import Foundation
import CoreLocation
import UIKit

class ContentModel:NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var resturants = [Business]()
    @Published var sights = [Business]()
    @Published var authorizationState = CLAuthorizationStatus.notDetermined

    var locationManager = CLLocationManager()
    private var cache = NSCache<NSString,UIImage>()

    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
 // MARK: - Location Manager Delegates Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied {
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            locationManager.stopUpdatingLocation()
            getBussinesses(category: Constants.sights, Location: userLocation)
            getBussinesses(category: Constants.restaurants, Location: userLocation)
        }
    }

    func getBussinesses(category: String, Location: CLLocation) {
        var urlComponets = URLComponents(string: "\(Constants.API_URL)")
        urlComponets?.queryItems = [
            URLQueryItem(name: "latitude", value: String(Location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(Location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]

        if let url = urlComponets?.url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.API_KEY)", forHTTPHeaderField: "Authorization")

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    print("there was an error")
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decoderResponse = try decoder.decode(BusinessSearch.self, from: data)
                        // sorting array by distance
                        var businesses = decoderResponse.businesses
                        businesses.sort { (b1, b2) -> Bool in
                            return b1.distance ?? 0 < b2.distance ?? 0
                        }

                        DispatchQueue.main.async {
                            switch category {
                                case Constants.restaurants:
                                    self.resturants = businesses
                                case Constants.sights:
                                    self.sights = businesses
                                default:
                                    break
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            dataTask.resume()
        }
    }
    func downloadImage(fromURLString: String, completed:@escaping(UIImage?) -> Void ) {
        let cacheKey = NSString(string: fromURLString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: fromURLString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data , let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
