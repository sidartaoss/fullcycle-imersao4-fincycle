package dto

type SearchResponse struct {
	ReportID  string `json:"-"`
	AccountID string `json:"-"`
	InitDate  string `json:"-"`
	EndDate   string `json:"-"`
	Took      int    `json:"took"`
	TimedOut  bool   `json:"timed_out"`
	Shards    struct {
		Total      int `json:"total"`
		Successful int `json:"successful"`
		Skipped    int `json:"skipped"`
		Failed     int `json:"failed"`
	} `json:"_shards"`
	Hits struct {
		Total struct {
			Value    int    `json:"value"`
			Relation string `json:"relation"`
		} `json:"total"`
		MaxScore float64 `json:"max_score"`
		Hits     []*struct {
			Index  string  `json:"_index"`
			Type   string  `json:"_type"`
			ID     string  `json:"_id"`
			Score  float64 `json:"_score"`
			Source *struct {
				ID          string  `json:"id"`
				PaymentDate int64   `json:"payment_date"`
				Name        string  `json:"name"`
				Description string  `json:"description"`
				Category    string  `json:"category"`
				Amount      float64 `json:"amount"`
				Type        string  `json:"type"`
				AccountID   string  `json:"account_id"`
				CreatedAt   int64   `json:"created_at"`
				UpdatedAt   int64   `json:"updated_at"`
			} `json:"_source"`
		} `json:"hits"`
	} `json:"hits"`
}
