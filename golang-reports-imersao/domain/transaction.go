package domain

import "github.com/sidartaoss/imersao4-reports/dto"

type TransactionRepository interface {
	Search(reportID string, accountID string, initDate string, endDate string) (dto.SearchResponse, error)
}
