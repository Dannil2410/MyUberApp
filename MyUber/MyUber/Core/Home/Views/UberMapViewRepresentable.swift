//
//  UberMapViewRepresentable.swift
//  UberApp
//
//  Created by Даниил Кизельштейн on 08.11.2023.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    @Binding var mapState: MapViewState
    
    let mapView = MKMapView()
 
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapviewAndRecenterOnUserLocation()
        case .locationSearch:
            break
        case .selectedLocation:
            if let coordinate = locationSearchViewModel.selectedLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestionationCoordinate: coordinate)
            }
        case .polylineAdded:
            break
        }
        
    }
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        //MARK: - Properties
        let parent: UberMapViewRepresentable
        
        private var userLocationCoordinate: CLLocationCoordinate2D?
        private var userLocationRegion: MKCoordinateRegion?
        
        
        //MARK: - Lifecircle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.userLocationRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        //MARK: - Helpers
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
        }
        
        func configurePolyline(withDestionationCoordinate toCoordinate: CLLocationCoordinate2D) {
            guard let fromCoordinate = userLocationCoordinate else { return }
            
            parent.locationSearchViewModel.getDestinationRoute(
                from: fromCoordinate,
                to: toCoordinate
            ) { [weak self] route in
                guard let self else { return }
                self.parent.mapView.addOverlay(route.polyline)
                
                self.parent.mapState = .polylineAdded
                
                let rect = self.parent.mapView.mapRectThatFits(
                    route.polyline.boundingMapRect,
                    edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapviewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            guard let region = userLocationRegion else { return }
            
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
