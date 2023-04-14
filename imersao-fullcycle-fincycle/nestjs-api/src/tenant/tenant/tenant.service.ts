import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/sequelize";
import { Account } from "../../accounts/entities/account.entity";

@Injectable()
export class TenantService {
  private account: Account | null;

  constructor(@InjectModel(Account) private accountModel: typeof Account) {}

  get tenant(): Account {
    return this.account;
  }

  set tenant(tenant: Account) {
    this.account = tenant;
  }

  async setTenantBy(subdomain: string) {
    this.tenant = await this.accountModel.findOne({
      where: {
        subdomain,
      },
      rejectOnEmpty: true,
    });
  }
}
