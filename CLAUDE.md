# iDoGym — Claude üçün Layihə Konteksti

## İstifadəçi haqqında
- SwiftUI öyrənən developer (Ferid)
- Hazır kod deyil, **öyrənmək** istəyir
- Hər kodu yazmadan əvvəl qısa izah istəyir (nə üçün, niyə bu struktur)
- Mürəkkəb hissələri sətir-sətir şərhlə istəyir
- Bir anda böyük kod bloku deyil, **addım-addım** irəliləmək istəyir
- Proaktiv təkliflər gözləyir
- Ünsiyyət dili: **Azərbaycan dili**

---

## Layihə haqqında
iOS fitness app. Auditoriya: idman/fitness edənlər.

**MVP Fokus:**
- Məşqlər (workouts) və hərəkətlər (exercises)
- Hər set üçün taymer (iş/dincəlmə intervalları)
- Sadə, tam ekran taymer təcrübəsi

---

## Arxitektura Qaydaları
- **Pattern:** MVVM + Repository Pattern
- **DI:** Protokol əsaslı Dependency Injection (`DependencyContainer`)
- **State:** iOS 17+ `@Observable` makrosu (`ObservableObject` **yox**)
- **Storage:** SwiftData (local, ilk mərhələ)
- **Navigation:** Mərkəzi `AppRouter` + `NavigationPath`

---

## Qovluq Strukturu
```
iDoGym/
├── Models/          — saf data strukturları (@Model)
├── Views/           — SwiftUI UI-lar
├── ViewModels/      — @Observable körpülər (View ↔ Repository)
├── Repositories/    — protokol + SwiftData implementasiyası
├── Services/        — TimerService və s.
├── DesignSystem/    — AppColors, AppFonts, AppSpacing
└── Core/            — DependencyContainer + AppRouter
```

---

## Mövcud Fayllar (yaradılıb)

**Models:** `Workout`, `WorkoutExercise`, `ExerciseSet`, `Exercise`, `MuscleGroup`, `ExerciseLog`

**Views:** `WorkoutListView`, `WorkoutDetailView`, `ActiveWorkoutView`, `ExercisePickerView`

**ViewModels:** `WorkoutListViewModel`, `WorkoutDetailViewModel`, `ActiveWorkoutViewModel`, `ExercisePickerViewModel`

**Repositories:** `WorkoutRepositoryProtocol`, `LocalWorkoutRepository`, `ExerciseRepositoryProtocol`, `LocalExerciseRepository`

**Services:** `TimerService`

**Core:** `DependencyContainer`, `AppRouter`

**DesignSystem:** `AppColors`, `AppFonts`, `AppSpacing`

---

## Gələcək Planlar (MVP-dən sonra)
- Statistika və tarixçə
- Apple Watch dəstəyi
- Backend API

---

## Kod Yazma Qaydaları
- Şərhlər Azərbaycan dilində yazılır (kod ingilis, şərh Azərbaycan)
- Hər yeni fayl düzgün qovluğa get
- `DesignSystem`-dən istifadə et (hardcoded rəng/font/spacing yox)
- `@Observable` işlət, `ObservableObject` işlətmə
