//
//  ContentView.swift
//  OnboardingUI with Auth
//
//  Created by Vraj Patel on 20/02/21.
//

import SwiftUI
import Lottie

struct ContentView: View {
    
    @State var goToHome = false
    var body: some View {
       
        ZStack{
            if goToHome{
                // Text("Home Screen")
                
                LoginUI()
            }
            else{
                SplashScreen()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Success")), perform: { _ in
            withAnimation{self.goToHome = true}
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SplashScreen: View{
    
    @State var show = false
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset : CGFloat = 0
    
    var body: some View{
        
        ZStack{
            VStack {
                AnimatedView(show: $show)
                
                // Slider...
                
                ZStack{
                    Capsule()
                        .fill(Color.black.opacity(0.2))
                    
                    // Background Progress...
                    
                    
                        Text("SWIPE TO START")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.leading,30)
                    
                    HStack{
                        Capsule()
                            .fill(Color.black)
                            .frame(width: calculateWidth() + 65)
                        
                        Spacer(minLength: 0)
                    }
                    
                    HStack{
                        
                        ZStack{
                            
                            Image(systemName: "chevron.right")
                            
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                        }
                        .foregroundColor(.white)
                        .offset(x: 5)
                        .frame(width: 65, height: 65)
                        .background(Color.black)
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChanged(value:))
                            .onEnded(onEnd(value:))
                        )
                        
                        
                        Spacer()
                    }
                }
                .frame(width: maxWidth, height: 65)
                .padding(.bottom)
            }
            
        }
    }
    
    func calculateWidth() -> CGFloat{
        
        let percent = offset / maxWidth
        
        return percent * maxWidth
    }
    
    func onChanged(value: DragGesture.Value){
        
        // Updating...
        
        
        if value.translation.width > 0 && offset <= maxWidth - 65{
            
            offset = value.translation.width
        }
    }

    func onEnd(value: DragGesture.Value){
        
        // back off animation...
        
        withAnimation(Animation.easeOut(duration: 0.3)){
            
            if offset > 180{
                
                offset = maxWidth - 65
                
                // Notifying User...
                
                // delaying for animation complete...
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                    
                    NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
                }
            }
            
            else {
                offset = 0
            }
        }
    }
}





// Animated View...

struct AnimatedView: UIViewRepresentable {
    
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> AnimationView {
        
       
        let view = AnimationView(name: "apple", bundle: Bundle.main)

        view.play{(status) in
            
            if status{
                // toggling View...
                
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8))
                {
                    show.toggle()
                }
            }
            
        }
        
        return view
    }
    func updateUIView(_ uiView: AnimationView, context: Context) {
        
    }
}

