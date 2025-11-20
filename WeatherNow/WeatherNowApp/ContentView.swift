import SwiftUI

struct ContentView: View {
    @State private var city: String = "Guadalajara"
    @State private var vm = WeatherViewModel(
        fetch: DefaultFetchWeatherUseCase(
            repo: APIWeatherRepository(client: URLSessionAPIClient())
        )
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("Ciudad", text: $city)
                    .textFieldStyle(.roundedBorder)
                Button("Buscar") { Task { await vm.load(city: city) } }
                    .buttonStyle(.borderedProminent)

                switch vm.state {
                case .idle:
                    Text("Ingresa una ciudad")
                        .foregroundStyle(.secondary)
                case .loading:
                    ProgressView()
                case .loaded(let w):
                    VStack {
                        Text(w.city).font(.title2).bold()
                        Text("\(Int(w.tempC))°C • \(w.description)")
                    }
                    .padding(.top, 8)
                case .error(let msg):
                    Text("Error: \(msg)").foregroundStyle(.red)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("WeatherNow")
        }
    }
}

#Preview { ContentView() }
