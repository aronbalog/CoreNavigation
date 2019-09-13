extension Navigation {
    public enum Direction {
        public enum Forward {
            case present
            case push
            case childViewController
        }
        public enum Back {
            case dismiss
            case pop
        }
        case forward(Forward)
        case back(Back)
    }
}
