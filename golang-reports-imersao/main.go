package main

import (
	"fmt"
	"log"

	ckafka "github.com/confluentinc/confluent-kafka-go/kafka"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/joho/godotenv"
	"github.com/sidartaoss/imersao4-reports/infra/kafka"
	"github.com/sidartaoss/imersao4-reports/infra/repository"
	"github.com/sidartaoss/imersao4-reports/usecase"
)

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("error loading .env file")
	}
}

func main() {
	client, err := elasticsearch.NewClient(elasticsearch.Config{
		Addresses: []string{"http://host.docker.internal:9200"},
	})
	if err != nil {
		log.Fatal("error connecting to elasticsearch")
	}
	repo := repository.TransactionElasticRepository{
		Client: *client,
	}

	msgChan := make(chan *ckafka.Message)
	consumer := kafka.NewKafkaConsumer(msgChan)
	go consumer.Consume()
	for msg := range msgChan {
		err = usecase.GenerateReport(msg.Value, repo)
		if err != nil {
			fmt.Println(err)
		}
	}
}
