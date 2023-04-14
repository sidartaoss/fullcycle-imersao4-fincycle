package usecase

import (
	"encoding/json"
	"html/template"
	"os"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	_ "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	_ "github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	_ "github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	_ "github.com/aws/aws-sdk-go/service/s3/s3manager"
	"github.com/sidartaoss/imersao4-reports/dto"
	"github.com/sidartaoss/imersao4-reports/infra/kafka"
	"github.com/sidartaoss/imersao4-reports/infra/repository"
)

func GenerateReport(requestJson []byte,
	repository repository.TransactionElasticRepository) error {
	var requestReport dto.RequestReport
	err := json.Unmarshal(requestJson, &requestReport)
	if err != nil {
		return err
	}
	data, err := repository.Search(requestReport.ReportID, requestReport.AccountID,
		requestReport.InitDate, requestReport.EndDate)
	if err != nil {
		return err
	}
	resultUrl, err := generateReportFile(data)
	if err != nil {
		return err
	}

	err = publishMessage(data.ReportID, string(resultUrl), "complete")
	if err != nil {
		return err
	}

	err = os.Remove("data/" + data.ReportID + ".html")
	if err != nil {
		return err
	}

	return nil
}

func generateReportFile(data dto.SearchResponse) ([]byte, error) {
	f, err := os.Create("data/" + data.ReportID + ".html")
	if err != nil {
		return nil, err
	}
	t := template.Must(template.New("report.html").ParseFiles("template/report.html"))
	err = t.Execute(f, data)
	if err != nil {
		return nil, err
	}
	resultUrl, err := uploadReport(data)
	if err != nil {
		return nil, err
	}
	return []byte(resultUrl), nil
}

func uploadReport(data dto.SearchResponse) (string, error) {
	sess := session.Must(session.NewSession())
	svc := s3.New(sess)

	uploader := s3manager.NewUploader(sess)

	fo, err := os.Open("data/" + data.ReportID + ".html")
	if err != nil {
		return "", err
	}

	_, err = uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(os.Getenv("S3Bucket")),
		Key:    aws.String(data.ReportID + ".html"),
		Body:   fo,
	})

	req, _ := svc.GetObjectRequest(&s3.GetObjectInput{
		Bucket: aws.String(os.Getenv("S3Bucket")),
		Key:    aws.String(data.ReportID + ".html"),
	})

	if err != nil {
		return "", err
	}
	reportTTL, err := strconv.ParseInt(os.Getenv("ReportTTL"), 10, 64)
	if err != nil {
		return "", err
	}
	urlStr, err := req.Presign(time.Duration(reportTTL) * time.Hour)
	if err != nil {
		return "", err
	}
	return urlStr, nil
}

func publishMessage(reportID string, fileUrl string, status string) error {
	responseReport := dto.ResponseReport{
		ID:      reportID,
		FileURL: fileUrl,
		Status:  status,
	}

	responseJson, err := json.Marshal(responseReport)
	if err != nil {
		return err
	}

	producer := kafka.NewKafkaProducer()
	producer.SetupProducer(os.Getenv("KafkaBootstrapServers"))
	err = producer.Publish(string(responseJson), os.Getenv("KafkaProducerTopic"))
	if err != nil {
		return err
	}

	return nil
}
