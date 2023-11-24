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
    
    @State var scale: Double = 1.5
    @State var angle: Angle = .degrees(1)
    @State var axis: (CGFloat, CGFloat, CGFloat) = (.zero, .zero, .zero)
    @State var activeObject: ModelObject?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                modelView()
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
                        .frame(maxWidth: 300, maxHeight: 300)
                        .rotation3DEffect(angle, axis: axis)
                        .simultaneousGesture(MagnifyGesture()
                            .onChanged({ magnifyValue in
                                if let initialScale {
                                    scale = max(1, min(4, magnifyValue.magnification * initialScale))
                                }
                                else {
                                    initialScale = scale
                                }
                            })
                                .onEnded({ magnifyValue in
                                    initialScale = scale
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
                            }))
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
