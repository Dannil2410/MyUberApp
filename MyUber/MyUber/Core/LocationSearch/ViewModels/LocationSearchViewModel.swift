//
//  LocationSearchViewModel.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import MapKit
import Combine

final class LocationSearchViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: UberLocation?
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var userLocationCoordinate: CLLocationCoordinate2D?
    private var updatePickUpAndDropOffTimeSubscription: AnyCancellable?
    
    private var expectedTravelTime: Double? = nil {
        didSet {
            guard let expectedTravelTime = expectedTravelTime else { return }
            configurePickUpAndDropOffTime(withExpectedTravelTime: expectedTravelTime)
            updatePickUpAndDropOffTime(withExpectedTravelTime: expectedTravelTime)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        return df
    }()
    
    var queryFragment: String = "" {
        didSet {
            if queryFragment == "" {
                results = []
            } else {
                searchCompleter.queryFragment = queryFragment
            }
        }
    }
    
    //MARK: - Lifecircle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    //MARK: - Public Functions
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { [weak self] response, error in
            
            guard let self else { return }
            
            if let error = error {
                print("DEBUG: location search failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            
            let coordinate = item.placemark.coordinate
            
            self.selectedLocation = UberLocation(
                title: localSearch.title,
                coordinate: coordinate)
        }
    }
    
    func setUserLocation(coordinate: CLLocationCoordinate2D) {
        self.userLocationCoordinate = coordinate
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let startCoordinate = userLocationCoordinate,
              let finishCoordinate = selectedLocation?.coordinate else { return 0 }
        
        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
        let finishLocation = CLLocation(latitude: finishCoordinate.latitude, longitude: finishCoordinate.longitude)
        
        let rideDistanceInMeters = finishLocation.distance(from: startLocation)
        return type.computePrice(forDistanceinMeters: rideDistanceInMeters)
    }
    
    func getDestinationRoute(
        from userLocation: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute) -> Void
    ) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: failed to get directions with error: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            self.expectedTravelTime = route.expectedTravelTime
            
            completion(route)
        }
    }
    
    func cancelSubscription() {
        updatePickUpAndDropOffTimeSubscription?.cancel()
        updatePickUpAndDropOffTimeSubscription = nil
        expectedTravelTime = nil
    }
    
    //MARK: - Private Functions
    
    private func locationSearch(
        forLocalSearchCompletion locationSearch: MKLocalSearchCompletion,
        completion: @escaping MKLocalSearch.CompletionHandler
    ) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationSearch.title.appending(locationSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    private func updatePickUpAndDropOffTime(withExpectedTravelTime expectedTravelTime: Double) {
        updatePickUpAndDropOffTimeSubscription = Timer.publish(every: 60, on: RunLoop.current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.configurePickUpAndDropOffTime(withExpectedTravelTime: expectedTravelTime)
            }
    }
    
    private func configurePickUpAndDropOffTime(withExpectedTravelTime expectedTravelTime: Double)  {
        pickUpTime = dateFormatter.string(from: .now)
        dropOffTime = dateFormatter.string(from: .now + expectedTravelTime)
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
