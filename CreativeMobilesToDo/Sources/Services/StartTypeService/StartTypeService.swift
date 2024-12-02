import Foundation

// MARK: - AppLaunchType
enum AppLaunchType {
    case firstTimeLaunch
    case subsequentLaunch
}

// MARK: - StartTypeService
final class StartTypeService: FirstStartIdentifiable {

    // MARK: - Dependencies
    private let defaults = UserDefaults.standard

    // MARK: - Public properties
    static let shared = StartTypeService()

    // MARK: - Private properties
    private var key = "startupKey"
    private var _launchType: AppLaunchType?

    var launchType: AppLaunchType {
        guard _launchType == nil else {
            return _launchType!
        }

        if defaults.bool(forKey: key) {
            _launchType = .subsequentLaunch
        } else {
            setAsAlreadyLaunched()
            _launchType = .firstTimeLaunch
        }

        return _launchType!
    }

    // MARK: - Private methods
    private func setAsAlreadyLaunched() {
        defaults.set(true, forKey: key)
    }
}
