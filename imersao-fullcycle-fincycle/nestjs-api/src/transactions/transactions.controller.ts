import { Body, Controller, Get, Post, Req, UseGuards } from "@nestjs/common";
import { TenantGuard } from "../tenant/tenant/tenant.guard";
import { JwtAuthGuard } from "../auth/jwt-auth.guard";
import { CreateTransactionDto } from "./dto/create-transaction.dto";
import { TransactionsService } from "./transactions.service";
import { TenantService } from "../tenant/tenant/tenant.service";

@UseGuards(JwtAuthGuard, TenantGuard)
@Controller("transactions")
export class TransactionsController {
  constructor(
    private readonly transactionsService: TransactionsService,
    private readonly tenantService: TenantService
  ) {}

  @Post()
  create(@Body() createTransactionDto: CreateTransactionDto) {
    return this.transactionsService.create(createTransactionDto);
  }

  @Get()
  findAll(@Req() req) {
    console.log("\n\n\n\n", this.tenantService.tenant);
    console.log("\n\n\n\n", req.user);

    return this.transactionsService.findAll();
  }
}
