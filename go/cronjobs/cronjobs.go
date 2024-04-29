package cronjobs

import (
	"context"
	"fmt"
	"time"
)

//ftl:cron */10 * * * * * *
func EveryTenSeconds(ctx context.Context) error {
	fmt.Printf("Every ten seconds: %d\n", time.Now().Second())
	return nil
}

//ftl:cron 0 * * * * * *
func EveryMinute(ctx context.Context) error {
	fmt.Printf("Every minute %v\n", time.Now().Minute())
	return nil
}

//ftl:cron 0 0 0 * * * *
func EveryDay(ctx context.Context) error {
	fmt.Printf("Every day\n")
	return nil
}

//ftl:cron */3 * * * * * *
func LongAndFrequentCronJob(ctx context.Context) error {
	fmt.Printf("Long and frequent: Started\n")
	time.Sleep(time.Second * 30)
	fmt.Printf("Long and frequent: Ended\n")
	return nil
}
