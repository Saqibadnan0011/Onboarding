//
//  OnboardingView.swift
//  Onboarding
//
//  Created by Saqib Adnan on 08/03/2024.
//


import SwiftUI

struct OnboardingView: View {
    
    
    
    // MARK: - GESTURE PROPERTIES
    @GestureState var isDragging: Bool = false
        
    @State var fakeIndex: Int = 0
    @State var currentIndex: Int = 0
    
    @Binding var done: Bool
    
    
    
    
    
    // MARK: - INTROS
    @State var intros: [Intro] = [
        Intro(title: "Welcome Docoder", subTitle: "Take Deep Breaths", description: "Community of passionate coders and learners. Whether you're a seasoned developer or just starting your coding journey.", img: "first", color: Color("Color1")),
            
        Intro(title: "Stay Creative", subTitle: "Keep Ideas Fresh", description: "Unlock the power of programming right from your smartphone, with hands-on exercises and real-time feedback.", img: "second", color: Color("Color2")),
            
        Intro(title: "Stay Focused", subTitle: "Create Task List", description: "Empower yourself with the convenience of learning programming languages anytime, anywhere, all from the palm of your hand.", img: "third", color: Color("Color3")),
        ]
        
    
    var body: some View {
        ZStack {
            ForEach(intros.indices.reversed(), id: \.self){index in
                //Intro View
                IntroView(intro: intros[index])
                    .clipShape(LiquidShape(offset: intros[index].offset, curvePoint: fakeIndex == index ? 50 : 0))
                    .padding(.trailing, fakeIndex == index ? 15: 0)
                    .ignoresSafeArea()
                    }
                HStack(spacing: 8) {
                    ForEach(0..<intros.count - 2, id: \.self){index in
                        Circle()
                            .fill(.gray)
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentIndex == index ? 1.15 : 0.85)
                            .opacity(currentIndex == index ? 1 : 0.25)
                        }
                        Spacer()
                    
                    Button {
                        self.done.toggle()
                    } label: {
                        Text("Let's Start")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            //.background()
                            .clipShape(Capsule())
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    .overlay (
                    
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                            .gesture(
                            DragGesture()
                                .updating($isDragging, body: {value, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                        intros[fakeIndex].offset = value.translation
                                    }
                                    
                                })
                                .onEnded({value in
                                    withAnimation(.spring()) {
                                        if -intros[fakeIndex].offset.width >
                                            getRect().width / 2 {
                                            intros[fakeIndex].offset.width = -getRect().height * 1.5
                                                fakeIndex += 1
                                                                    
                // MARK: - UPDATE ORIGINAL INDEX
                if currentIndex == intros.count - 3 {
                        currentIndex = 0
                    } else {
                        currentIndex += 1
                    }
                // MARK: - RESETING INDEX
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if fakeIndex == (intros.count - 2) {
                        for index in 0..<intros.count - 2 {
                            intros[index].offset = .zero
                    }
                    fakeIndex = 0
                    }
                }
            } else { intros[fakeIndex].offset = .zero }
                    }
                })
                )
            })
            .offset(y: 53)
            .opacity(isDragging ? 0 : 1)
            .animation(.linear, value: isDragging)
            ,alignment: .topTrailing
        )
        .onAppear{
            guard let first = intros.first else {
                return
            }
            guard var last = intros.last else {
                return
            }
            last.offset.width = -getRect().height * 1.5
                    
                intros.append(first)
                intros.insert(last, at: 0)
                    
                fakeIndex = 1
                }
            }
    
    @ViewBuilder
        func IntroView(intro: Intro) -> some View {
            VStack {
                
                Image(intro.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(40)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(intro.title)
                        .font(.system(size: 30)).bold()
                        .textCase(.uppercase)
                    
//                    Text(intro.subTitle)
//                        .font(.system(size: 36, weight: .bold))
                    
                    Text(intro.description)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .padding(.top)
                        .frame(width: getRect().width - 100)
                        .lineSpacing(7)
                    
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding([.trailing, .top])
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    intro.color
                    )
                }
            }

#Preview {
    OnboardingView(done: .constant(false))
}

// MARK: - VIEW ETENSION

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}

struct LiquidShape: Shape {
    var offset: CGSize
    var curvePoint: CGFloat
    
    // MARK: SHAPE ANIMATION
    var animatableData: AnimatablePair<CGSize.AnimatableData, CGFloat>{
        get{
            return AnimatablePair(offset.animatableData, curvePoint)
        }
        set{
            offset.animatableData = newValue.first
            curvePoint = newValue.second
        }
    }
    func path(in rect: CGRect) -> Path {
        return Path{path in
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
                    
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
                    
            // MARK: - FROM
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
                    
            // MARK: - TO
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
                    
            let mid : CGFloat = 80 + ((to - 80) / 2)
                    
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - curvePoint, y: mid), control2: CGPoint(x: width - curvePoint, y: mid))
        }
    }
}

