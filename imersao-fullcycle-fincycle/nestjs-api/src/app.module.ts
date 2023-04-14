import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { SequelizeModule } from "@nestjs/sequelize";
import { AccountsModule } from "./accounts/accounts.module";
import { Account } from "./accounts/entities/account.entity";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { AuthModule } from "./auth/auth.module";
import { CommonModule } from "./common/common.module";
import { Report } from "./reports/entities/report.entity";
import { ReportsModule } from "./reports/reports.module";
import { TenantModule } from "./tenant/tenant.module";
import { Transaction } from "./transactions/entities/transaction.entity";
import { TransactionsModule } from "./transactions/transactions.module";
import { MyAccountController } from "./accounts/my-account/my-account.controller";

@Module({
  imports: [
    ConfigModule.forRoot(),
    SequelizeModule.forRoot({
      dialect: process.env.DB_CONNECTION as any,
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_DATABASE,
      models: [Transaction, Account, Report],
      autoLoadModels: true,
      synchronize: true,
      sync: {
        alter: true,
      },
    }),
    TransactionsModule,
    AccountsModule,
    CommonModule,
    AuthModule,
    TenantModule,
    ReportsModule,
  ],
  controllers: [AppController, MyAccountController],
  providers: [AppService],
})
export class AppModule {}
