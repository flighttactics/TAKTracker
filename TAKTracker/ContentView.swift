//
//  ContentView.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    let broadcastRepeatTime = 5.0
    
    @StateObject var manager = LocationManager()
    var takManager = TAKManager()
    
    @State var tracking:MapUserTrackingMode = .none
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Current Location:")
            Text($manager.region.wrappedValue.center.latitude.formatted() + ", " + $manager.region.wrappedValue.center.longitude.formatted())
            Button("Send Location", action: { takManager.broadcastLocation(location: $manager.region.wrappedValue.center, userId: "TayTay")})
            Map(
               coordinateRegion: $manager.region,
               interactionModes: MapInteractionModes.all,
               showsUserLocation: true,
               userTrackingMode: $tracking
            )
        }
        .padding()
        .onAppear {
            NSLog("Appeared")
            Timer.scheduledTimer(withTimeInterval: broadcastRepeatTime, repeats: true) { timer in
                broadcastLocation()
           }
        }
    }
    
    func broadcastLocation() {
        NSLog("timer fired!")
        takManager.broadcastLocation(location: $manager.region.wrappedValue.center, userId: "TayTay")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
