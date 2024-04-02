//
//  ObjectView.swift
//  Showroom
//
//  Created by Luka Lešić on 07.11.2023..
//

import SwiftUI
import RealityKit

struct ObjectView: View {
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager
    //object manipulation
    @State var initialScale: Double?
    @State var initialAngle: Angle?
    @State var initialAxis: (CGFloat, CGFloat, CGFloat)?
    
    @State var scale: Double = 1
    @State var angle: Angle = .degrees(1)
    @State var axis: (CGFloat, CGFloat, CGFloat) = (.zero, .zero, .zero)
    @State var activeObject: ModelObject?
    
    @State private var isDisplayingInfoPopup = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    modelView()
                    if isDisplayingInfoPopup {
                        ObjectInfoPopup()
                            .environment(manager)
                            .zIndex(5)
                    }
                }
                Text(self.activeObject?.name ?? "not assigned")
            }
        }
        .onAppear {
            self.activeObject = manager.activeObject
        }
    }
}

private extension ObjectView {
        
    @ViewBuilder
    func modelView() -> some View {
        if let modelURL = self.activeObject?.modelURL, let url = URL(string: modelURL) {
            Model3D(url: url) { phase in
                switch phase {
                case .success(let model):
                    model
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 1500, maxHeight: 1500)
                        .rotation3DEffect(angle, axis: axis)
                        .scaleEffect(scale)
                        .scaleEffect(isDisplayingInfoPopup ? 0.75 : 1)
                        .onTapGesture {
                            withAnimation(.bouncy(extraBounce: 0.4)) {
                                isDisplayingInfoPopup.toggle()
                            }
                        }
                        .simultaneousGesture(MagnifyGesture()
                            .onChanged({ magnifyValue in
                                if let initialScale {
                                    scale = max(0.2, min(1.5, magnifyValue.magnification * initialScale))
                                }
                                else {
                                    initialScale = scale
                                }
                            })
                                .onEnded({ magnifyValue in
                                    initialScale = scale
                                    SoundManager.shared.playSound(soundName: "correct")
                                }))
                    
                        .simultaneousGesture(DragGesture()
                            .onChanged({ dragValue in
                                if let initialAngle, let initialAxis {
                                    let _angle = sqrt(pow(dragValue.translation.width, 2) + pow(dragValue.translation.height, 2)) + initialAngle.degrees
                                    let XAxis = ((-dragValue.translation.height + initialAxis.0) / CGFloat(_angle))
                                    let YAxis = ((dragValue.translation.width + initialAxis.1) / CGFloat(_angle))
                                    angle = Angle(degrees: Double(_angle))
                                    axis = (XAxis, YAxis, 0)
                                } else {
                                    initialAxis = axis
                                    initialAngle = angle
                                }
                            }).onEnded({ dragValue in
                                initialAxis = axis
                                initialAngle = angle
                                SoundManager.shared.playSound(soundName: "correct")
                            }))
                        .zIndex(2)
                case .failure(let error):
                    Text(error.localizedDescription)
                default:
                    ProgressView()
                        .frame(width: 300, height: 300)
                }
            }
        }
    }
}


struct ObjectInfoPopup: View {
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager
    
    var body: some View {
        ZStack {
            VStack {
                Text(manager.activeObject?.name ?? "")
                    .foregroundStyle(.white)
                    .font(.system(size: 60, weight: .bold))
                Text(manager.activeObject?.description ?? "No description")
                    .font(.system(size: 30))
                    .padding(.top, 35)
                    .padding(.horizontal)
                Text("Price: \(manager.activeObject?.price ?? 0) EUR")
                    .font(.system(size: 30))
                addToCartButton()
            }
        }
        .padding(.all, 35)
        .padding(.vertical, 35)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: 800, maxHeight: 800)
        .scaleEffect(1.4)
    }
}


extension ObjectInfoPopup {
    @ViewBuilder
    func addToCartButton() -> some View {
        Button {
            CartManager.shared.addToCart(object: manager.activeObject!)
            SoundManager.shared.playSound(soundName: "ding")
        } label: {
            Text("\(Image(systemName: "cart")) Add to cart")
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }

}
