# WeatherNow (Swift/SwiftUI)

Plantilla de portafolio para iOS **lista para git**, con arquitectura **MVVM + Clean**, módulos, lint y CI.

## Objetivo
Demostrar networking, cache y calidad de código con **Swift/SwiftUI**; base que puedes reutilizar para otros proyectos.

## Estructura
```
WeatherNow/
├─ WeatherNowApp/                # App (SwiftUI)
├─ Core/                         # Domain layer
│  ├─ Models/
│  ├─ UseCases/
│  ├─ Repositories/
│  └─ DesignSystem/
├─ Networking/                   # API client + endpoints
├─ Persistence/                  # Cache/persistencia
├─ Features/
│  └─ Weather/
│     ├─ Domain/
│     ├─ Data/
│     └─ Presentation/
└─ Tests/
   ├─ Unit/
   └─ UI/
```

## Requisitos
- Xcode 15/16, iOS 17/18
- SwiftLint (opcional): `brew install swiftlint`

## Cómo crear el proyecto Xcode (5 min)
1. **Xcode → File → New → Project… → iOS App**  
   - **Product Name:** `WeatherNow`  
   - **Interface:** SwiftUI · **Language:** Swift · **Use Core Data:** desmarcado
2. En el navegador de Xcode, **arrastra** las carpetas `WeatherNowApp`, `Core`, `Networking`, `Persistence`, `Features`, `Tests` dentro del proyecto (selecciona **Create folder references** o **Create groups**).
3. Selecciona el target `WeatherNow` → **General** → **iOS Deployment Target** ≥ 17.0.
4. `⌘B` para compilar.

## Lint
- Config en `.swiftlint.yml`.

## CI (GitHub Actions)
- Workflow en `.github/workflows/ios.yml`. Se ejecuta cuando existan archivos `.xcodeproj` en el repo.

## Git (flujo sugerido)
- `main` protegido. Ramas: `feat/...`, `fix/...`, `docs/...`, `chore/...`, `test/...`
- Commits con Conventional Commits.

## Roadmap sugerido
- [ ] Cache TTL por ciudad (SwiftData/archivo)
- [ ] Estados de error vacíos y reintento
- [ ] Localización ES/EN
- [ ] Accesibilidad (Dynamic Type/VoiceOver)
- [ ] Widgets y notificaciones
