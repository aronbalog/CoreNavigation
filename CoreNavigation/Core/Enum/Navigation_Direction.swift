extension Navigation {
    public enum Direction {
        public enum Forward {
            case present
            case push
            case childViewController
        }
        public enum Back {
            case automatic
            case dismiss
            case pop
            case popToRootViewController
        }
        case forward(Forward)
        case back(Back)
        case segue(String)
    }
}
