import Foundation

@Observable
final class TimerService {

    enum Phase: Equatable {
        case idle       // başlamamış
        case running    // işləyir
        case paused     // dayandırılıb
        case finished   // geri sayım bitdi (yalnız countdown-da)
    }

    private(set) var phase: Phase = .idle
    private(set) var elapsed: TimeInterval = 0    // keçən vaxt
    private(set) var remaining: TimeInterval = 0  // qalan vaxt (countdown-da)

    private var totalDuration: TimeInterval = 0
    private var isCountdown = false
    private var timer: Timer?

    // MARK: - Açıq interfeys

    // İrəli sayım — məşq müddəti üçün
    func startCountup() {
        reset()
        isCountdown = false
        phase = .running
        scheduleTimer()
    }

    // Geri sayım — dincəlmə müddəti üçün
    func startCountdown(from duration: TimeInterval) {
        reset()
        totalDuration = duration
        remaining = duration
        isCountdown = true
        phase = .running
        scheduleTimer()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        phase = .paused
    }

    func resume() {
        guard phase == .paused else { return }
        phase = .running
        scheduleTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        reset()
        phase = .idle
    }

    // Geri sayıma əlavə vaxt (+/- düymələri üçün)
    func addTime(_ seconds: TimeInterval) {
        guard isCountdown else { return }
        totalDuration += seconds
        remaining = max(0, remaining + seconds)
    }

    // MARK: - Görüntü

    var displayTime: String {
        let time = isCountdown ? remaining : elapsed
        return TimerService.format(time)
    }

    static func format(_ time: TimeInterval) -> String {
        let total = Int(time)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }

    // MARK: - Daxili

    private func reset() {
        elapsed = 0
        remaining = 0
    }

    private func scheduleTimer() {
        // .common mode — scroll zamanı da timer işləsin
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func tick() {
        elapsed += 1
        if isCountdown {
            remaining = max(0, totalDuration - elapsed)
            if remaining == 0 {
                phase = .finished
                timer?.invalidate()
                timer = nil
            }
        }
    }
}
