import SwiftUI
import MapKit

struct BusinessMapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: ContentModel
    @Binding var selectedBusiness: Business?


    var location: [MKPointAnnotation] {
        var annotaions = [MKPointAnnotation]()

        for business in viewModel.resturants + viewModel.sights {
            //create a new annotaion
            let annotaion = MKPointAnnotation()
            //if the business has lat/long, create a MKPointAnnotion for it
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude {
                annotaion.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotaion.title = business.name

                annotaions.append(annotaion)
            }
        }
        return annotaions
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        // add and show anotaions based on businesses
        uiView.showAnnotations(location, animated: true)
    }

    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }

    class Coordinator: NSObject,MKMapViewDelegate {

        var map: BusinessMapView

        init(map:BusinessMapView ) {
            self.map = map
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            // check if there is any reuseable anotion view
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotaionReuseId)

            if annotationView == nil {
                // create an annotation view
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotaionReuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            } else {
                // reuse the annotation
                annotationView?.annotation = annotation
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // user tapped on the annotationView
            // loop through resturants and sights and find the match
            for business in map.viewModel.resturants + map.viewModel.sights {
                if business.name == view.annotation?.title {
                    //set the selectedBusiness to the business user tapped on
                    map.selectedBusiness = business
                    return
                }
            }
        }
    }
}
