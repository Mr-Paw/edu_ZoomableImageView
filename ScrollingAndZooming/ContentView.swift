//
//  ContentView.swift
//  ScrollingAndZooming
//
//  Created by mr paw on 27.09.2023.
//  Copyright © 2023 mrpaw69. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage? = .init(named: "image")
    var body: some View {
        ZoomableImage(image: image)
    }
}

#Preview {
    ContentView()
}
