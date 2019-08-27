extension DataPassing {
    enum Strategy {
        case sync(Any)
        case async((DataPassing.Context<Any>) -> Void)
    }
}
