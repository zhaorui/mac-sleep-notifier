package notifier

import "C"

//export CanSleep
func CanSleep() C.int {
	// always allow sleep
	return 1
}

//export WillWake
func WillWake() {
	notifierCh <- &Activity{
		Type: WillAwake,
	}
}

//export HasWake
func HasWake() {
	notifierCh <- &Activity{
		Type: Awake,
	}
}

//export WillSleep
func WillSleep() {
	notifierCh <- &Activity{
		Type: Sleep,
	}
}
