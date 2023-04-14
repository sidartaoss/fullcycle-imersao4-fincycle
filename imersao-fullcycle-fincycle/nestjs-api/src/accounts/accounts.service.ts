import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/sequelize";
import { CreateAccountDto } from "./dto/create-account.dto";
import { Account } from "./entities/account.entity";

@Injectable()
export class AccountsService {
  constructor(@InjectModel(Account) private accountModel: typeof Account) {}

  create(createAccountDto: CreateAccountDto) {
    return this.accountModel.create({
      name: createAccountDto.name,
      balance: createAccountDto.balance,
      subdomain: createAccountDto.subdomain,
    });
  }

  findAll() {
    return this.accountModel.findAll();
  }

  findOne(id: string) {
    return this.accountModel.findByPk(id, {
      rejectOnEmpty: true,
    });
  }
}
