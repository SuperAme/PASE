//
//  CharacterMapView.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

import SwiftUI
import MapKit

struct CharacterMapView: View {
    let characterName: String
    let coordinate: CLLocationCoordinate2D

    @State private var region: MKCoordinateRegion

    init(characterName: String, coordinate: CLLocationCoordinate2D) {
        self.characterName = characterName
        self.coordinate = coordinate
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [MapPin(coordinate: coordinate, title: characterName)]) { pin in
            MapMarker(coordinate: pin.coordinate, tint: .blue)
        }
        .navigationTitle("Ubicación de \(characterName)")
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
