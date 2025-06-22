import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
}

struct ResultView: View {
    var phase: String
    var date: Date
    var city: String
    
    @State private var glow = false
    @State private var stars: [Star] = []
    let starCount = 35
    
    var body: some View {
        ZStack {
            Image("resultbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            LinearGradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.75)],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            ForEach(stars) { star in
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x, y: star.y)
            }
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("🌙")
                        .font(.system(size: 44))
                    Text("Moon Phase Revealed")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(colors: [.white, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(color: .yellow.opacity(0.3), radius: 3)
                        .multilineTextAlignment(.center)
                }
                VStack(spacing: 4) {
                    Text("In \(city), on \(formattedDate(date))")
                    Text("the moon phase is:")
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                Text(phase)
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.6), radius: 4)
                Image(phaseImageName(for: phase))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 220)
                    .shadow(color: .white.opacity(glow ? 0.6 : 0.3), radius: glow ? 25 : 10)
                    .scaleEffect(glow ? 1.015 : 1.0)
                    .onAppear { glow = true }
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glow)
                VStack(spacing: 10) {
                    Text("Did You Know?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(funFact(for: phase))
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: 320)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer(minLength: 16)
            }
            .padding(.top, 10)
        }
        .onAppear {
            generateStars()
            animateStars()
        }
    }
    func generateStars() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        stars = (0..<starCount).map { _ in
            Star(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight),
                size: CGFloat.random(in: 1.5...3.5),
                speed: CGFloat.random(in: 0.4...1.2)
            )
        }
    }
    
    func animateStars() {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            for i in 0..<stars.count {
                stars[i].y += stars[i].speed
                if stars[i].y > UIScreen.main.bounds.height {
                    stars[i].y = 0
                    stars[i].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                }
            }
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    func phaseImageName(for phase: String) -> String {
        switch phase {
        case "🌑 New Moon": return "new_moon"
        case "🌒 Waxing Crescent": return "waxing_crescent"
        case "🌓 First Quarter": return "first_quarter"
        case "🌔 Waxing Gibbous": return "waxing_gibbous"
        case "🌕 Full Moon": return "full_moon"
        case "🌖 Waning Gibbous": return "waning_gibbous"
        case "🌗 Last Quarter": return "last_quarter"
        case "🌘 Waning Crescent": return "waning_crescent"
        default: return "unknown"
        }
    }
    func funFact(for phase: String) -> String {
        switch phase {
        case "🌑 New Moon":
            return "The sky is dark and quiet — the Moon hides completely. It’s the perfect time to set intentions or simply take a moment to reset and dream big."
        case "🌒 Waxing Crescent":
            return "A small silver curve appears. This phase reminds us to stay hopeful, take small steps, and believe something bright is beginning."
        case "🌓 First Quarter":
            return "Half the Moon is glowing. This phase is all about action — facing challenges and building on what you’ve started."
        case "🌔 Waxing Gibbous":
            return "The Moon grows fuller each night. It’s a sign to keep going, refine your plans, and stay focused — your efforts will shine soon."
        case "🌕 Full Moon":
            return "The Moon is at its brightest. It’s a time of energy, clarity, and celebration. Emotions feel stronger and everything more alive."
        case "🌖 Waning Gibbous":
            return "The light begins to dim, but wisdom shines. This phase is for sharing what you’ve learned and reflecting on your journey."
        case "🌗 Last Quarter":
            return "Half the Moon again, now fading. It encourages letting go of what no longer serves and finishing what you started."
        case "🌘 Waning Crescent":
            return "Only a thin sliver remains. The Moon invites you to slow down, rest deeply, and prepare for a fresh start."
        default:
            return "The Moon is always changing — just like us. Every phase tells its own quiet story."
        }
    }
}
