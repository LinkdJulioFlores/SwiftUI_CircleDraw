//
//  TapPractice.swift
//  Practice
//
//  Created by Julio Flores on 11/21/23.
//

import SwiftUI

struct Main: View {
    @Environment (\.colorScheme) var colorScheme
    @State var touchLocations: [Location] = []
    @State var chosenColor: Color = .red
    @State private var size: CGFloat = 65.0
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(15)
                    .onTapGesture { location in
                        let finalLocation = CGPoint(x: location.x, y: location.y)
                        withAnimation(.spring){
                            touchLocations.append(Location(location: finalLocation,
                                                           chosenColor: chosenColor,
                                                           chosenSize: size
                                                          )
                                                 )
                        }
                    }
                ForEach(touchLocations){ item in
                    Circle()
                        .frame(width: item.chosenSize, height: item.chosenSize)
                        .position(item.location)
                        .foregroundStyle(item.chosenColor)
                    Text(String(format: "%.2f", item.chosenSize))
                        .position(item.location)
                        .font(.system(size: item.chosenSize * 0.3))
                        .foregroundStyle(.white)
                }
            }
            Spacer()
            Slider(
                value: $size,
                in: 30...100
            )
            .tint(colorScheme == .dark ? .white : .black)
            VStack{
                HStack{
                    ColorButtonView(chosenColor: $chosenColor)
                }
                Tools(touchLocation: $touchLocations)
            }
        }
        .padding()
    }
}

#Preview {
    Main()
}

struct Location: Identifiable {
    let id = UUID()
    var location: CGPoint
    var chosenColor: Color
    var chosenSize: CGFloat
    
}

struct ColorButtonView: View {
    @Binding var chosenColor: Color
    var body: some View {
        Button {
            chosenColor = Color.red
        } label: {
            Text("Red")
                .font(.title2)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        Button {
            chosenColor = Color.green
        } label: {
            Text("Green")
                .font(.title2)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        Button {
            chosenColor = Color.blue
        } label: {
            Text("Blue")
                .font(.title2)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
        Button {
            chosenColor = Color.orange
        } label: {
            Text("Oj")
                .font(.title2)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
    }
}

struct Tools: View {
    @Environment (\.colorScheme) var colorScheme
    @Binding var touchLocation: [Location]
    @State private var redoArray: [Location] = []
    @State private var buttonHeight: CGFloat = 0
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring){
                    
                    if !redoArray.isEmpty {
                        withAnimation(.spring){
                            touchLocation.append(redoArray.last!)
                            redoArray.removeLast()
                        }
                    }
                }
            } label: {
                Text("Undo")
                    .frame(maxWidth: .infinity, maxHeight: buttonHeight - 10)
                    .font(.title)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
            }
            .buttonStyle(.borderedProminent)
            .tint(colorScheme == .dark ? .white : .black)
            
            GeometryReader { geometry in
                VStack {
                    Button{
                            if !touchLocation.isEmpty{
                                if let lastLocation = touchLocation.last {
                                    redoArray.append(lastLocation)
                                }
                                touchLocation.removeLast()
                        }
                    } label: {
                        Text("Pop Last")
                            .frame(maxWidth: .infinity)
                            .font(.title)
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorScheme == .dark ? .white : .black)
                    
                    Button {
                        withAnimation(.spring()){
                            
                            if !touchLocation.isEmpty {
                                touchLocation.removeAll()
                                redoArray.removeAll()
                            }
                        }
                    } label: {
                        Text("Pop All")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorScheme == .dark ? .white : .black)
                }
            }
            .frame(height: 100)
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        buttonHeight = proxy.size.height // Capture the height of the VStack
                    }
            })
        }
    }
}
