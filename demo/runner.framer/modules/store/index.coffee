{ createStore, combineReducers, applyMiddleware, compose } = require "redux"
{ rootReducer } = require "store/rootReducer"

composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
# { composeWithDevTools } = require 'redux-devtools-extension'

# composeEnhancers = composeWithDevTools({
# 	sendTo: 'http://localhost:8000',
# 	actionsBlacklist: ['tick'],
# })


store = createStore(
	rootReducer,
	composeEnhancers(
		# applyMiddleware(thunk, epicMiddleware, soundsMiddleware)
	),
)

exports.getState = store.getState
exports.dispatch = store.dispatch
exports.subscribe = store.subscribe
