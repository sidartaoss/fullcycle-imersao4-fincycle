import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/sequelize";
import { TenantService } from "../tenant/tenant/tenant.service";
import { CreateReportDto } from "./dto/create-report.dto";
import { UpdateReportDto } from "./dto/update-report.dto";
import { Report } from "./entities/report.entity";

@Injectable()
export class ReportsService {
  constructor(
    @InjectModel(Report) private reportModel: typeof Report,
    private tenantService: TenantService
  ) {}

  create(createReportDto: CreateReportDto) {
    return this.reportModel.create({
      ...createReportDto,
      account_id: this.tenantService.tenant.id,
    });
  }

  async update(id: string, updateReportDto: UpdateReportDto) {
    updateReportDto.file_url = updateReportDto.file_url.substring(0, 255);
    const report = await this.reportModel.findByPk(id, {
      rejectOnEmpty: true,
    });
    return await report.update(updateReportDto);
  }

  findAll() {
    return this.reportModel.findAll({
      where: {
        account_id: this.tenantService.tenant.id,
      },
    });
  }
}
