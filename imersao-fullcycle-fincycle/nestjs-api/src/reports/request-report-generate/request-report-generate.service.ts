import { Inject, Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/sequelize";
import { Report } from "../entities/report.entity";
import { Producer } from "@nestjs/microservices/external/kafka.interface";

@Injectable()
export class RequestReportGenerateService {
  constructor(
    @InjectModel(Report) private reportModel: typeof Report,
    @Inject("KAFKA_PRODUCER")
    private kafkaProducer: Producer
  ) {
    this.reportModel.afterCreate((instance, options) => {
      this.afterCreate(instance);
    });
  }

  async afterCreate(instance: Report) {
    await this.kafkaProducer.send({
      topic: "reported.requested",
      messages: [
        {
          key: "reports",
          value: JSON.stringify({
            id: instance.id,
            start_date: instance.start_date.toISOString().substring(0,10),
            end_date: instance.end_date.toISOString().substring(0,10),
            account_id: instance.account_id,
          }),
        },
      ],
    });
  }
}
