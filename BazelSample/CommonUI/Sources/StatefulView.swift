import Foundation
import UIKit

@frozen public enum State: Equatable {
    case loading
    case content
    case empty(EmptyState)
}

public protocol StatefulView: AnyObject {

    /// The current state of the `StatefulObject`.
    var currentState: State? { get set }

    /// The UIVIew where state changes are applied.
    var stateView: UIView? { get }

    /// Performs a transition to a different state.
    /// If you want to react to a specific state transition (like updating a tableView), you should implement the `adapt()` method in your object.
    /// Before calling `adapt()`, the action of transitioning between states first triggers a specific set of default behaviors in a view (like displaying/dismissing loading indicators), controlled by the `prepare` method of the new state. If you want to change the **default** behavior of each state (like **not** displaying an indicator when transitioning to `.loading`, you can override these methods to do so. For everything else unrelated to the default actions (aka additional actions) you should use the `adapt()` method.
    func transition(toState state: State, animated: Bool)

    /// Performs additional actions after transitioning to a state.
    /// You should use this method to make objects react to state transitions, like updating a tableView.
    /// For information on how to change the **default** behavior of a state, see `transition()`.
    func adapt(toState state: State, animated: Bool)

    /// These methods need to be on the protocol in order to have implementations of them in subclasses of UIView called
    /// You can look up for protocol witness table in order to understand why only having the default implementation and subclass implementation won't work
    func prepareLoadingState(animated: Bool)
    func prepareContentState(animated: Bool)
    func prepareEmptyState(_ emptyState: EmptyState, animated: Bool)
}

public extension StatefulView where Self: UIView {
    var stateView: UIView? { self }
}

public extension StatefulView {

    func transition(toState state: State, animated: Bool = true) {
        switch state {
        case .loading:
            prepareLoadingState(animated: animated)
        case .content:
            prepareContentState(animated: animated)
        case .empty(let filler):
            prepareEmptyState(filler, animated: animated)
        }
        adapt(toState: state, animated: animated)
        currentState = state
    }

    /// Called when transitioning to the `.loading` state.
    /// Never call this method directly! This is called automatically when transitioning.
    /// You can override it to change the default behavior of `.loading` states.
    /// If your intention is to add **additional** actions to this state, use the `adapt()` method.
    func prepareLoadingState(animated: Bool) {
        stateView?.showLoadingView(animated: animated)
        stateView?.hideEmptyStateView(animated: animated)
    }

    /// Called when transitioning to the `.content` state.
    /// Never call this method directly! This is called automatically when transitioning.
    /// You can override it to change the default behavior of `.content` states.
    /// If your intention is to add **additional** actions to this state, use the `adapt()` method.
    func prepareContentState(animated: Bool) {
        stateView?.hideLoadingView(animated: animated)
        stateView?.hideEmptyStateView(animated: animated)
    }

    /// Called when transitioning to the `.empty` state.
    /// Never call this method directly! This is called automatically when transitioning.
    /// You can override it to change the default behavior of `.empty` states.
    /// If your intention is to add **additional** actions to this state, use the `adapt()` method.
    func prepareEmptyState(_ emptyState: EmptyState, animated: Bool) {
        stateView?.hideLoadingView(animated: animated)
        stateView?.showEmptyStateView(emptyState, animated: animated)
    }
}
