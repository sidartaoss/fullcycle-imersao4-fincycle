package repository

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/elastic/go-elasticsearch/v8"
	"github.com/sidartaoss/imersao4-reports/dto"
)

type TransactionElasticRepository struct {
	elasticsearch.Client
}

func (r TransactionElasticRepository) Search(reportID string, accountID string,
	initDate string, endDate string) (dto.SearchResponse, error) {
	layout := "2006-01-02"
	initDateTimestamp, err := time.Parse(layout, initDate)
	if err != nil {
		return dto.SearchResponse{}, err
	}
	// endDateTimestamp, err := time.Parse(layout, endDate)
	// if err != nil {
	// 	return dto.SearchResponse{}, err
	// }

	data := `
	{
		"query": {
			"bool": {
			"must": [
				{
				"match": {
					"account_id": "` + accountID + `"
				}
				}
			],
			"filter": [
				{
				"range": {
					"payment_date": {
					"gte": ` + strconv.FormatInt(initDateTimestamp.Unix()*int64(1000), 10) + `
					}
				}
				}
			]
			}
		}
	}
	`

	response, err := r.Client.Search(
		r.Client.Search.WithIndex(os.Getenv("ElasticIndex")),
		r.Client.Search.WithBody(strings.NewReader(data)),
		r.Client.Search.WithTrackTotalHits(true),
	)
	if err != nil {
		return dto.SearchResponse{}, err
	}

	body, error := ioutil.ReadAll(response.Body)
	if error != nil {
		fmt.Println(error)
	}

	var searchResponse dto.SearchResponse
	err = json.Unmarshal(body, &searchResponse)
	if err != nil {
		log.Printf("error unmarshaling response: %+v", err)
	}

	defer response.Body.Close()

	searchResponse.ReportID = reportID
	searchResponse.AccountID = accountID
	searchResponse.InitDate = initDate
	searchResponse.EndDate = endDate

	return searchResponse, nil
}
