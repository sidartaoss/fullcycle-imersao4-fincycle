package kafka

import (
	ckafka "github.com/confluentinc/confluent-kafka-go/kafka"
)

type KafkaProducer struct {
	*ckafka.Producer
	DeliveryChan chan ckafka.Event
}

func NewKafkaProducer() KafkaProducer {
	return KafkaProducer{}
}

func (k *KafkaProducer) SetupProducer(bootstrapServers string) {
	configMap := &ckafka.ConfigMap{
		"bootstrap.servers": bootstrapServers,
	}
	k.Producer, _ = ckafka.NewProducer(configMap)
}

func (k *KafkaProducer) Publish(msg string, topic string) error {
	message := &ckafka.Message{
		TopicPartition: ckafka.TopicPartition{Topic: &topic, Partition: ckafka.PartitionAny},
		Value:          []byte(msg),
	}
	err := k.Producer.Produce(message, k.DeliveryChan)
	if err != nil {
		return err
	}
	return nil
}
