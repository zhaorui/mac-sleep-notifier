package main

import (
	"log"

	"github.com/zhaorui/mac-sleep-notifier/notifier"
)

func main() {
	log.Printf("starting sleep notifier ...")
	notifierCh := notifier.GetInstance().Start()

	for activity := range notifierCh {
		switch activity.Type {
		case notifier.WillAwake:
			log.Println("machine will awake")
		case notifier.Awake:
			log.Println("machine awake")
		case notifier.Sleep:
			log.Println("machine sleeping")
		default:
			log.Printf("unknown activity type: %v", activity.Type)
		}
	}
}
