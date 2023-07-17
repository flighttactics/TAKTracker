//
//  ContentView.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI
import MapKit

struct MainScreen: View {
    @EnvironmentObject var settingsStore: SettingsStore
    
    @StateObject var manager = LocationManager()
    var takManager = TAKManager()
    
    @State var tracking:MapUserTrackingMode = .none
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
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
                            Text("\(manager.lastLocation?.coordinate.latitude.formatted() ?? "0")")
                            Spacer()
                        }.font(.system(size: 30))
                        HStack {
                            Spacer()
                            Text("Lon")
                            Spacer()
                            Text("\(manager.lastLocation?.coordinate.longitude.formatted() ?? "0")")
                            Spacer()
                        }.font(.system(size: 30))
                    }
                    .border(.blue)
                    .foregroundColor(.white)
                    .background(.black)
                    .padding(10)
                    
                    HStack {
                        VStack {
                            Text("Heading (°TN)")
                                .frame(maxWidth: .infinity)
                            Text("\(manager.lastHeading?.trueHeading.formatted() ?? "0")").font(.system(size: 30))
                        }
                        .background(.black)
                        .border(.blue)
                        VStack {
                            Text("Compass (°MN)")
                                .frame(maxWidth: .infinity)
                            Text("\(manager.lastHeading?.magneticHeading.formatted() ?? "0")").font(.system(size: 30))
                        }
                        .background(.black)
                        .border(.blue)
                        VStack {
                            Text("Speed (m/s)")
                                .frame(maxWidth: .infinity)
                            Text("\(manager.lastLocation?.speed.formatted() ?? "0")").font(.system(size: 30))
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
                }
                .background(lightGray)
                .padding()
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = settingsStore.disableScreenSleep
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
