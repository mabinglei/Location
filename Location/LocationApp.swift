//
//  LocationApp.swift
//  Location
//
//  Created by Binglei Ma on 3/1/25.
//

import SwiftUI
import MapKit

@main
struct LocationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var locationManager = LocationManager()
    var body: some View {
        Map(position: $locationManager.location) {
            UserAnnotation()
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    var location: MapCameraPosition
    
    override init() {
        self.location = MapCameraPosition.region(.init(center: .init(), span: span))
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        withAnimation(.smooth(duration: 1.0)) {
            self.location = MapCameraPosition.region(.init(center: newLocation.coordinate, span: span))
        }
    }
}

#Preview {
    ContentView()
}
