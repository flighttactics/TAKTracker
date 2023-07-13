//
//  ContentView.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    
    @StateObject var manager = LocationManager()
    var takManager = TAKManager()
    
    @State var tracking:MapUserTrackingMode = .none
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Text("TAK Tracker")
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "exclamationmark.triangle")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .onTapGesture {
                            navigateAlert()
                        }
                    Spacer()
                    Image(systemName: "bubble.left")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .onTapGesture {
                            navigateChat()
                        }
                    Spacer()
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .onTapGesture {
                            navigateSettings()
                        }
                    Spacer()
                }.background(darkGray)
                Text("Current Location:").foregroundColor(.white).bold()
                Text($manager.region.wrappedValue.center.latitude.formatted() + ", " + $manager.region.wrappedValue.center.longitude.formatted()).foregroundColor(.white)
                if(settingsStore.enableAdvancedMode) {
                    Map(
                       coordinateRegion: $manager.region,
                       interactionModes: MapInteractionModes.all,
                       showsUserLocation: true,
                       userTrackingMode: $tracking
                    )
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
    
    func navigateAlert() {
        NSLog("Navigate Alert")
    }
    
    func navigateChat() {
        NSLog("Navigate Chat")
    }
    
    func navigateSettings() {
        NSLog("Navigate Settings")
        settingsStore.enableAdvancedMode.toggle()
        //settingsStore.$enableAdvancedMode = true
    }
    
    func broadcastLocation() {
        takManager.broadcastLocation(location: $manager.region.wrappedValue.center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
