import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var city = ""
    @State private var showResult = false
    @State private var predictedPhase: String = ""
    @State private var confidence: Double = 0.0
    @State private var animateStars = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("2")
                    .resizable()
                    .scaledToFill()
                    .brightness(-0.48)
                    .opacity(0.89)
                    .ignoresSafeArea()

                ForEach(0..<35, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: CGFloat.random(in: 1.5...4.0))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .opacity(animateStars ? 1 : 0.2)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2.5...4.5))
                                .repeatForever()
                                .delay(Double(i) / 14),
                            value: animateStars
                        )
                }

                VStack(spacing: 30) {
                    Text("NovaMoon")
                        .font(.custom("Georgia-Bold", size: 36))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 4)

                    Text("“Trace the moon’s journey through time and sky.”")
                        .font(.system(size: 16, weight: .light, design: .serif))
                        .italic()
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.15), Color.clear]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 120
                            ))
                            .frame(width: 160, height: 160)
                            .blur(radius: 6)

                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.6), radius: 6)
                    }

                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Label {
                                Text("Choose a Night")
                                    .font(.custom("Georgia-Bold", size: 22))
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 4)
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                            }

                            HStack {
                                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                    .labelsHidden()
                                Spacer()
                            }
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Label {
                                Text("Your City of Skywatching")
                                    .font(.custom("Georgia-Bold", size: 22))
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 4)
                            } icon: {
                                Image(systemName: "location")
                                    .foregroundColor(.white)
                            }

                            TextField("Ex: Chennai, Tokyo, Paris", text: $city)
                                .padding(15)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)

                    Button(action: {
                        if !city.isEmpty {
                            let dateOnly = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)) ?? selectedDate
                            let area = MoonData.area(for: dateOnly) ?? 0.5
                            if let result = MoonPhasePredictor()?.predictPhase(from: dateOnly, area: area) {
                                predictedPhase = result.phase
                                confidence = result.confidence
                                showResult = true
                            } else {
                                predictedPhase = "❌ Couldn't Predict"
                                confidence = 0.0
                                showResult = true
                            }
                        }
                    }) {
                        Text("Reveal the Moon's Phase")
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.9)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .foregroundColor(Color.black.opacity(0.8))
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    NavigationLink(
                        destination: ResultView(phase: predictedPhase, date: selectedDate, city: city),
                        isActive: $showResult
                    ) {
                        EmptyView()
                    }

                    Spacer()
                }
                .frame(maxWidth: 420)
                .padding()
            }
            .onAppear {
                MoonData.loadCSV()
                animateStars = true
            }
        }
    }
}
