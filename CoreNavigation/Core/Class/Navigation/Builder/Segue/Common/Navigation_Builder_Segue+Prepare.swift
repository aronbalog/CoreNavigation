extension Navigation.Builder.Segue {
    @discardableResult public func prepare(_ block: @escaping (_ segue: UIStoryboardSegue, _ sender: Any?) -> Void) -> Self {
        queue.sync { configuration.prepareForSegueBlock = block }
        
        return self
    }
}
