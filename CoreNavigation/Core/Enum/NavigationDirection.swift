public enum NavigationDirection {
    public enum Forward {
        case present
        case push
        case childViewController
    }
    public enum Backward {
        case dismiss
        case pop
    }
    case forward(Forward)
    case backward(Backward)
}
