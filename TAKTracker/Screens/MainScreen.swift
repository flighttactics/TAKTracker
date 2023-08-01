//
//  ContentView.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI
import MapKit

struct MainScreen: View {
    @StateObject var manager = LocationManager()
    @StateObject var settingsStore = SettingsStore.global
    var takManager = TAKManager()
    
    @State var tracking:MapUserTrackingMode = .none
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    func formatOrZero(item: Double?, formatter: String = "%.0f") -> String {
        guard let item = item else {
            return "0"
        }
        return String(format: formatter, item)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        Text("TAK Tracker")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink(destination: AlertView()) {
                            Image(systemName: "exclamationmark.triangle")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        NavigationLink(destination: ChatView(chatMessage: ChatMessage())) {
                            Image(systemName: "bubble.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }.background(darkGray)
                    
                    Text(settingsStore.callSign).foregroundColor(.white).bold()
                    
                    VStack(alignment: .leading) {
                        Text("Location")
                        HStack {
                            Spacer()
                            Text("Lat").font(.system(size: 30))
                            Spacer()
                            Text(formatOrZero(item: manager.lastLocation?.coordinate.latitude, formatter: "%.4f"))
                            Spacer()
                        }.font(.system(size: 30))
                        HStack {
                            Spacer()
                            Text("Lon")
                            Spacer()
                            Text(formatOrZero(item: manager.lastLocation?.coordinate.longitude,
                                formatter: "%.4f"))
                            Spacer()
                        }.font(.system(size: 30))
                    }
                    .border(.blue)
                    .foregroundColor(.white)
                    .background(.black)
                    .padding(10)
                    
                    HStack(alignment: .center) {
                        VStack {
                            Text("Heading")
                                .frame(maxWidth: .infinity)
                            Text("(°TN)")
                                .frame(maxWidth: .infinity)
                            Text(formatOrZero(item: manager.lastHeading?.trueHeading) + "°").font(.system(size: 30))
                        }
                        .background(.black)
                        .border(.blue)
                        VStack {
                            Text("Compass")
                                .frame(maxWidth: .infinity)
                            Text("(°MN)")
                                .frame(maxWidth: .infinity)
                            Text(formatOrZero(item: manager.lastHeading?.magneticHeading) + "°").font(.system(size: 30))
                        }
                        .background(.black)
                        .border(.blue)
                        VStack {
                            Text("Speed")
                                .frame(maxWidth: .infinity)
                            Text("(m/s)")
                                .frame(maxWidth: .infinity)
                            Text(formatOrZero(item: manager.lastLocation?.speed)).font(.system(size: 30))
                        }
                        .background(.black)
                        .border(.blue)
                    }
                    .foregroundColor(.white)
                    .padding(10)

                    if(settingsStore.enableAdvancedMode) {
                        Map(
                           coordinateRegion: $manager.region,
                           interactionModes: MapInteractionModes.all,
                           showsUserLocation: true,
                           userTrackingMode: $tracking
                        )
                        .border(.black)
                    }
                    Spacer()
                    HStack {
                        if(settingsStore.isConnectedToServer) {
                            Text("Server: Connected").foregroundColor(.green)
                        } else {
                            Text("Server: \(settingsStore.connectionStatus)").foregroundColor(.red)
                        }
                    }
                    .font(.system(size: 15))
                }
                .background(lightGray)
                .padding()
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: settingsStore.broadcastIntervalSeconds, repeats: true) { timer in
                        broadcastLocation()
                   }
                }
              }
            }
        }
    
    func broadcastLocation() {
        guard let location = manager.lastLocation else {
            return
        }
        takManager.broadcastLocation(location: location)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
