import SwiftUI

struct ContentView: View {
    @State private var rotation = 0.0
    @State private var showingBack = false
    @State private var selectedCard = 0
    @State private var showWhitePage = false
    @State private var showQR = false
    @State private var isLoading = false
    @State private var userName = "Hilma Laring"
    @State private var personalNumber = "050119-0065"
    @State private var showProfile = false

    var body: some View {
        ZStack {
            Color(red: 17/255, green: 17/255, blue: 17/255)
                .ignoresSafeArea()
            
          
                

            BouncingLogo(x: 50,  y: 100, dx: 0.35, dy: 0.25)
            BouncingLogo(x: 150, y: 200, dx: -0.25, dy: 0.20)
            BouncingLogo(x: 300, y: 80,  dx: 0.30, dy: -0.20)
            BouncingLogo(x: 380, y: 350, dx: -0.35, dy: -0.25)
            BouncingLogo(x: 80,  y: 500, dx: 0.20, dy: -0.30)
            BouncingLogo(x: 250, y: 600, dx: -0.30, dy: 0.18)
            BouncingLogo(x: 350, y: 750, dx: 0.25, dy: -0.22)
            BouncingLogo(x: 120, y: 800, dx: -0.22, dy: -0.25)

            TabView(selection: $selectedCard) {
                FlippableCard(frontImage: "stukFront", backImage: "stukBack", userName: userName, personalNumber: personalNumber)
                    .tag(0)

                FlippableCard(frontImage: "stukFrontGbg", backImage: "stukBack", userName: userName, personalNumber: personalNumber)
                    .tag(1)
                
                FlippableCard(
                    frontImage: "casa_front",
                    backImage: "casa_back",
                    userName: userName,
                    personalNumber: personalNumber
                )
                    .tag(2)
                    
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 60)
            .offset(y: -30)
            
            if isLoading {
                GeometryReader { geometry in
                    Image("load_card")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .clipped()
                        .ignoresSafeArea()
                }
                .zIndex(5)
                .allowsHitTesting(false)

                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.3)
                    .offset(y:20)
                    .zIndex(6)
            }
            
            VStack {
                Spacer()

                HStack {
                    // LEFT
                    Button("Stäng") {
                        showWhitePage = true
                    }
                    .foregroundStyle(.white)

                    Spacer()

                    // MIDDLE
                    if !isLoading {
                        HStack(spacing: 6) {
                            ForEach(0..<3) { index in
                                ZStack {
                                    Circle()
                                        .fill(selectedCard == index ? Color.white : Color.black)
                                        .frame(width: 30, height: 30)

                                    Text("\(index + 1)")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(
                                            selectedCard == index ? Color.black : Color.white
                                        )
                                }
                            }
                        }
                    }

                    Spacer()

                    // RIGHT
                    Button {
                        showQR = true
                    } label: {
                        Image("qr")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .opacity(isLoading ? 0.4 : 1)
                    .disabled(isLoading)

                    Button {
                        isLoading = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isLoading = false
                        }
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                    }
                    .opacity(isLoading ? 0.4 : 1)
                    .disabled(isLoading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 25)
                .padding(.bottom, 15)
                .background(
                    Color(red: 17/255, green: 17/255, blue: 17/255)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            .offset(y: 15)
            .zIndex(10)
            
            if showQR {
                Color.black
                    .opacity(0.50)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showQR = false
                        }
                    }
            }

            GeometryReader { geometry in
                Image("qr_display")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: min(1.05 * 799 / 2, max(0, geometry.size.width - 32)),
                        height: min(1.05 * 1248 / 2, geometry.size.height)
                    )
                    .scaleEffect(showQR ? 1 : 0.01)
                    .opacity(showQR ? 1 : 0)
                    .animation(
                        showQR ? .spring(response: 0.3, dampingFraction: 0.8) : nil,
                        value: showQR
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .allowsHitTesting(showQR)
            .zIndex(2)
            if showWhitePage {
                NewsView(
                    openCards: {
                        showWhitePage = false
                    },
                    openProfile: {
                        showProfile = true
                    }
                )
                    .zIndex(100)
            }
            if showProfile {
                ProfileView(
                    userName: $userName,
                    personalNumber: $personalNumber,
                    close: {
                        showProfile = false
                    }
                )
                .zIndex(200)
            }
        }
    }
//end
    func flipCard() {
        let newRotation = showingBack ? 0.0 : 180.0

        withAnimation(.easeInOut(duration: 0.3)) {
            rotation = newRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            showingBack.toggle()
        }
    }
}

struct BouncingLogo: View {
    @State private var position: CGPoint
    @State private var velocity: CGVector

    init(x: CGFloat, y: CGFloat, dx: CGFloat, dy: CGFloat) {
        _position = State(initialValue: CGPoint(x: x, y: y))
        _velocity = State(initialValue: CGVector(dx: dx, dy: dy))
    }

    let logoSize: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Image("stuk_logo_gray")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: logoSize, height: logoSize)
                    .position(position)
                    .onChange(of: timeline.date) {
                        updatePosition(in: geometry.size)
                    }
            }
        }
    }

    private func updatePosition(in size: CGSize) {
        position.x += velocity.dx
        position.y += velocity.dy

        let half = logoSize / 2

        if position.x <= -half || position.x >= size.width + half {
            velocity.dx *= -1
        }

        if position.y <= -half || position.y >= size.height + half {
            velocity.dy *= -1
        }
    }
}

struct FlippableCard: View {
    let frontImage: String
    let backImage: String

    var userName: String? = nil
    var personalNumber: String? = nil

    @State private var rotation = 0.0
    @State private var showingBack = false

    // Casa back image coordinates (906 × 1440 pixels).
    // X is the text line's center; Y is where the text starts, measured from the top.
    // Change these values to move each line independently.
    private let casaNamePosition = CGPoint(x: 225, y: 85)
    private let casaIDPosition = CGPoint(x: 175, y: 85)
    private let casaTextSize: CGFloat = 36
    private let casaImageSize = CGSize(width: 906, height: 1440)

    // STUK front image coordinates (1272 × 2020 pixels).
    // X is the line center; Y is the text start.
    private let stukNamePosition = CGPoint(x: 470, y: 115)
    private let stukIDPosition = CGPoint(x: 415, y: 115)
    private let gbgNamePosition = CGPoint(x: 470, y: 115)
    private let gbgIDPosition = CGPoint(x: 415, y: 115)
    private let stukTextSize: CGFloat = 40
    private let stukImageSize = CGSize(width: 1272, height: 2020)

    private var isCasa: Bool { frontImage == "casa_front" }
    private var textImageSize: CGSize { isCasa ? casaImageSize : stukImageSize }
    private var namePosition: CGPoint {
        isCasa ? casaNamePosition : (frontImage == "stukFrontGbg" ? gbgNamePosition : stukNamePosition)
    }
    private var idPosition: CGPoint {
        isCasa ? casaIDPosition : (frontImage == "stukFrontGbg" ? gbgIDPosition : stukIDPosition)
    }

    var body: some View {
        GeometryReader { geometry in
            card
                .scaleEffect(0.90)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private var card: some View {
        ZStack {
            Image(showingBack ? backImage : frontImage)
                .resizable()
                .scaledToFit()
                .overlay {
                    if showingBack == isCasa,
                       let userName = userName,
                       let personalNumber = personalNumber {
                        GeometryReader { geometry in
                            let scale = min(
                                geometry.size.width / textImageSize.width,
                                geometry.size.height / textImageSize.height
                            )
                            let origin = CGPoint(
                                x: (geometry.size.width - textImageSize.width * scale) / 2,
                                y: (geometry.size.height - textImageSize.height * scale) / 2
                            )

                            cardText(userName, at: namePosition, scale: scale, origin: origin)
                            cardText(personalNumber, at: idPosition, scale: scale, origin: origin)
                        }
                    }
                }
                .padding(5)
                .scaleEffect(x: showingBack ? -1 : 1, y: 1)
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            flipCard()
        }
    }

    private func cardText(_ text: String, at point: CGPoint, scale: CGFloat, origin: CGPoint) -> some View {
        let lineWidth: CGFloat = isCasa ? 1200 : 800

        return Text(text)
            .font(.system(size: (isCasa ? casaTextSize : stukTextSize) * scale, weight: .medium))
            .foregroundStyle(.black)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: lineWidth * scale, height: 44 * scale, alignment: .leading)
            .rotationEffect(.degrees(90))
            .position(
                x: origin.x + point.x * scale,
                y: origin.y + (point.y + lineWidth / 2) * scale
            )
    }

    private func flipCard() {
        let newRotation = showingBack ? 0.0 : 180.0

        withAnimation(.easeInOut(duration: 0.3)) {
            rotation = newRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            showingBack.toggle()
        }
    }
}

struct NewsView: View {
    let openCards: () -> Void
    let openProfile: () -> Void

    @State private var topLogoOpacity: Double = 0
    @State private var showSearch = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        HeroView(height: min(750, geometry.size.height * 0.9)) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showSearch = true
                            }
                        }
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onChange(of: geo.frame(in: .global).maxY) { _, maxY in
                                            let start: CGFloat = 300   // fade starts
                                            let end: CGFloat = 150     // fully visible

                                            topLogoOpacity = Double(
                                                min(max((start - maxY) / (start - end), 0), 1)
                                            )
                                        }
                                }
                            )

                        section(title: "Back To School 📚", offers: backToSchoolOffers)

                        section(title: "Populärt just nu", offers: popularOffers)

                        section(title: "TV, ljud & streaming", offers: streamingOffers)

                        section(title: "Mode", offers: fashionOffers)

                        section(title: "Träning & outdoor", offers: fitnessOffers)

                        section(title: "Mobil & bredband", offers: mobileOffers)

                        section(title: "Hem & vardag", offers: homeOffers)

                        section(title: "Beauty", offers: beautyOffers)

                        section(title: "Gör vardagen billigare", offers: everydayOffers)

                        section(title: "Underhållning", offers: entertainmentOffers)

                        section(title: "Inför helgen", offers: weekendOffers)

                        section(title: "Studentfavoriter", offers: studentFavorites)

                        Spacer()
                            .frame(height: 100)
                    }
                }
                .frame(width: geometry.size.width)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    bottomNavigation
                }
                .ignoresSafeArea(edges: .top)

                VStack {
                    HStack {
                        Button {
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 22))
                                .foregroundStyle(.white)
                                .frame(width: 55, height: 55)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Image("stuk_logo_white")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: 130, height: 80)
                            .opacity(topLogoOpacity)

                        Spacer()

                        Button {
                        } label: {
                            Image(systemName: "location.circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                                .frame(width: 55, height: 55)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.top, 10)
                
                if showSearch {
                    SearchView {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showSearch = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(10)
                }
                
            }
        }
    }
        

    private var bottomNavigation: some View {
        HStack(spacing: 0) {
            Image(systemName: "house.fill")
                .frame(maxWidth: .infinity, minHeight: 52)
            Image(systemName: "star")
                .frame(maxWidth: .infinity, minHeight: 52)
            Button(action: openCards) {
                Image(systemName: "creditcard")
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .contentShape(Rectangle())
            }
            Image(systemName: "ticket")
                .frame(maxWidth: .infinity, minHeight: 52)
            Button(action: openProfile) {
                Image(systemName: "person.crop.circle")
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .contentShape(Rectangle())
            }
        }
        .buttonStyle(.plain)
        .font(.system(size: 25))
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black)
    }

    private var placeholderCard: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.35))
            .frame(width: 220, height: 180)
    }

    func section(title: String, offers: [OfferItem]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(offers) { offer in
                        if let url = URL(string: offer.url) {
                            Link(destination: url) {
                                Image(offer.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 260, height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct HeroView: View {
    let height: CGFloat
    let openSearch: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {

            // Dark gradient at bottom
            VStack {
                Spacer()

                LinearGradient(
                    colors: [
                        .clear,
                        .black.opacity(0.4),
                        .black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 300)
            }

            VStack {
                
                Spacer()

                Button("Till erbjudandet") {
                }
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.horizontal, 50)
                .padding(.vertical, 16)
                .background(.white)
                .clipShape(Capsule())
                .padding(.top, 15)
                
                Button {
                    openSearch()
                } label: {
                    HStack {
                        Text("Vad letar du efter?")
                            .foregroundStyle(.gray)

                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .font(.system(size: 22))
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 55)
                    .background(Color(red: 35/255, green: 35/255, blue: 35/255))
                    .clipShape(Capsule())
                }
                .font(.system(size: 17))
                .padding(.horizontal, 20)
                .padding(.top, 25)

                Spacer()
                    .frame(height: 50)
            }
            .padding(.top, 20)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background {
            GeometryReader { geometry in
                Image("hero")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
        .clipped()
    }
}

struct SearchView: View {
    let close: () -> Void

    @State private var searchText = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 20) {

                // Search + close
                HStack(spacing: 10) {

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)

                        TextField("Sök...", text: $searchText)
                            .foregroundStyle(.white)
                            .tint(.white)
                            .focused($searchFocused)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color(red: 35/255,
                                      green: 35/255,
                                      blue: 35/255))
                    .clipShape(Capsule())

                    Button {
                        close()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                            .background(Color(red: 35/255,
                                              green: 35/255,
                                              blue: 35/255))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)

                // Temporary placeholder for your image
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 60)
        }
        .onAppear {
            searchFocused = true
        }
    }
}

struct OfferItem: Identifiable {
    let id = UUID()
    let image: String
    let url: String
}

let backToSchoolOffers = [
    OfferItem(image: "education_first", url: "https://www.ef.se"),
    OfferItem(image: "bookbeat", url: "https://www.bookbeat.se"),
    OfferItem(image: "storytel", url: "https://www.storytel.com/se"),
    OfferItem(image: "weekday", url: "https://www.weekday.com")
]

let popularOffers = [
    OfferItem(image: "zalando", url: "https://www.zalando.se"),
    OfferItem(image: "gymshark", url: "https://se.gymshark.com"),
    OfferItem(image: "ica", url: "https://www.ica.se"),
    OfferItem(image: "bookbeat", url: "https://www.bookbeat.se"),
    OfferItem(image: "hallon", url: "https://www.hallon.se")
]

let streamingOffers = [
    OfferItem(image: "tv4_play", url: "https://www.tv4play.se"),
    OfferItem(image: "storytel", url: "https://www.storytel.com/se"),
    OfferItem(image: "bookbeat", url: "https://www.bookbeat.se"),
    OfferItem(image: "comviq1", url: "https://www.comviq.se")
]

let fashionOffers = [
    OfferItem(image: "weekday", url: "https://www.weekday.com"),
    OfferItem(image: "zalando", url: "https://www.zalando.se"),
    OfferItem(image: "björnborg", url: "https://www.bjornborg.com/se"),
    OfferItem(image: "rvrc", url: "https://www.revolutionrace.se"),
    OfferItem(image: "gymshark", url: "https://se.gymshark.com")
]

let fitnessOffers = [
    OfferItem(image: "fitness24_7", url: "https://se.fitness24seven.com"),
    OfferItem(image: "iciw", url: "https://www.icaniwill.se"),
    OfferItem(image: "gymshark", url: "https://se.gymshark.com"),
    OfferItem(image: "björnborg", url: "https://www.bjornborg.com/se"),
    OfferItem(image: "rvrc", url: "https://www.revolutionrace.se")
]

let mobileOffers = [
    OfferItem(image: "hallon", url: "https://www.hallon.se"),
    OfferItem(image: "comviq1", url: "https://www.comviq.se"),
    OfferItem(image: "comviq2", url: "https://www.comviq.se")
]

let homeOffers = [
    OfferItem(image: "ikea", url: "https://www.ikea.com/se/sv/"),
    OfferItem(image: "ica", url: "https://www.ica.se"),
    OfferItem(image: "makeup", url: "https://makeup.se")
]

let beautyOffers = [
    OfferItem(image: "makeup", url: "https://makeup.se"),
    OfferItem(image: "zalando", url: "https://www.zalando.se"),
    OfferItem(image: "weekday", url: "https://www.weekday.com")
]

let everydayOffers = [
    OfferItem(image: "ica", url: "https://www.ica.se"),
    OfferItem(image: "ikea", url: "https://www.ikea.com/se/sv/"),
    OfferItem(image: "hallon", url: "https://www.hallon.se"),
    OfferItem(image: "comviq2", url: "https://www.comviq.se")
]

let entertainmentOffers = [
    OfferItem(image: "tv4_play", url: "https://www.tv4play.se"),
    OfferItem(image: "bookbeat", url: "https://www.bookbeat.se"),
    OfferItem(image: "storytel", url: "https://www.storytel.com/se")
]

let weekendOffers = [
    OfferItem(image: "rvrc", url: "https://www.revolutionrace.se"),
    OfferItem(image: "iciw", url: "https://www.icaniwill.se"),
    OfferItem(image: "tv4_play", url: "https://www.tv4play.se"),
    OfferItem(image: "ica", url: "https://www.ica.se"),
    OfferItem(image: "zalando", url: "https://www.zalando.se")
]

let studentFavorites = [
    OfferItem(image: "education_first", url: "https://www.ef.se"),
    OfferItem(image: "fitness24_7", url: "https://se.fitness24seven.com"),
    OfferItem(image: "hallon", url: "https://www.hallon.se"),
    OfferItem(image: "weekday", url: "https://www.weekday.com"),
    OfferItem(image: "bookbeat", url: "https://www.bookbeat.se"),
    OfferItem(image: "comviq1", url: "https://www.comviq.se")
]

struct ProfileView: View {
    @Binding var userName: String
    @Binding var personalNumber: String

    let close: () -> Void

    private enum Field: Hashable {
        case name, personalNumber
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // Top bar
                    HStack {
                        Button {
                            close()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 26))
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(Color(red: 35/255, green: 35/255, blue: 35/255))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Profil")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundStyle(.white)

                        Spacer()

                        Button {
                            // Search later
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(Color(red: 35/255, green: 35/255, blue: 35/255))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)

                    // Personal information
                    VStack(spacing: 0) {

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Namn")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)

                            TextField("Namn", text: $userName)
                                .focused($focusedField, equals: .name)
                                .textContentType(.name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .personalNumber }
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white)
                                .tint(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)

                        Divider()
                            .background(Color.gray.opacity(0.3))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Personnummer")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)

                            TextField("Personnummer", text: $personalNumber)
                                .focused($focusedField, equals: .personalNumber)
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                                .tint(.white)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    }
                    .background(Color(red: 18/255, green: 18/255, blue: 18/255))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.top, 35)

                    // Menu
                    VStack(spacing: 0) {
                        profileRow(icon: "person.crop.rectangle", title: "Redigera profil")
                        Divider().background(Color.gray.opacity(0.3))

                        profileRow(icon: "ticket", title: "Mina biljetter")
                        Divider().background(Color.gray.opacity(0.3))

                        profileRow(icon: "heart", title: "Mina rabatter")
                    }
                    .background(Color(red: 18/255, green: 18/255, blue: 18/255))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.top, 25)

                    VStack(spacing: 0) {
                        profileRow(icon: "gearshape", title: "Inställningar")
                        Divider().background(Color.gray.opacity(0.3))

                        profileRow(icon: "doc.text", title: "Allmänna villkor")
                        Divider().background(Color.gray.opacity(0.3))

                        profileRow(icon: "lock.shield", title: "Integritetspolicy")
                        Divider().background(Color.gray.opacity(0.3))

                        profileRow(icon: "envelope", title: "Medlemsservice")
                    }
                    .background(Color(red: 18/255, green: 18/255, blue: 18/255))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.top, 25)

                }
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if focusedField != nil {
                HStack {
                    Spacer()
                    Button("Klart") { focusedField = nil }
                        .fontWeight(.semibold)
                        .frame(minWidth: 44, minHeight: 44)
                }
                .padding(.horizontal, 20)
                .background(Color.black)
            }
        }
    }

    private func profileRow(icon: String, title: String) -> some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 23))
                .frame(width: 30)
                .foregroundStyle(.white)

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 20)
        .frame(height: 72)
    }
}
