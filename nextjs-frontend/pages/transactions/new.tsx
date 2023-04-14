import {
  Box,
  Button,
  Container,
  Grid,
  MenuItem,
  TextField,
  Typography,
} from "@material-ui/core";
import { useKeycloak } from "@react-keycloak/ssr";
import { GetServerSideProps, GetServerSidePropsContext, NextPage } from "next";
import { useRouter } from "next/router";
import { useForm } from "react-hook-form";
import { Token, validateAuth } from "../../utils/auth";
import makeHttp from "../../utils/http";
import {
  TransactionCategoryLabels,
  TransactionTypeLabels,
} from "../../utils/model";

export const TransactionsNewPage: NextPage = () => {
  const { register, handleSubmit } = useForm();
  const router = useRouter();
  const { initialized, keycloak } = useKeycloak();

  const onSubmitHandler = async (data: any) => {
    try {
      await makeHttp().post("transactions", data);
      router.push("/transactions");
    } catch (error) {
      console.log(error);
    }
  };

  if (
    typeof window !== "undefined" &&
    initialized &&
    !keycloak?.authenticated
  ) {
    router.replace(`/login?from=${window!.location.pathname}`);
    return null;
  }

  return keycloak?.authenticated ? (
    <Container>
      <Typography component="h1" variant="h4">
        Nova Transação
      </Typography>
      <form onSubmit={handleSubmit(onSubmitHandler)}>
        <Grid container>
          <Grid item xs={12} md={6}>
            <TextField
              {...register("payment_date")}
              type="date"
              required
              label="Data pagamento"
              fullWidth
              InputLabelProps={{
                shrink: true,
              }}
            />
            <TextField
              {...register("name")}
              label="Nome"
              required
              fullWidth
              inputProps={{ maxLength: 255 }}
            />
            <TextField
              {...register("description")}
              label="Descrição"
              required
              fullWidth
            />
            <TextField
              {...register("category")}
              select
              required
              label="Categoria"
              fullWidth
            >
              {TransactionCategoryLabels.map((i: any, key: any) => (
                <MenuItem key={key} value={i.value}>
                  {i.label}
                </MenuItem>
              ))}
            </TextField>
            <TextField
              {...register("amount", { valueAsNumber: true })}
              required
              type="number"
              label="Valor"
              fullWidth
            />
            <TextField
              {...register("type")}
              select
              required
              label="Tipo de operação"
              fullWidth
            >
              {TransactionTypeLabels.map((i: any, key: any) => (
                <MenuItem key={key} value={i.value}>
                  {i.label}
                </MenuItem>
              ))}
            </TextField>
            <Box marginTop={1}>
              <Button
                type="submit"
                variant="contained"
                color="primary"
                fullWidth
              >
                Salvar
              </Button>
            </Box>
          </Grid>
        </Grid>
      </form>
    </Container>
  ) : null;
};

export default TransactionsNewPage;

export const getServerSideProps: GetServerSideProps = async (
  ctx: GetServerSidePropsContext
) => {
  const auth = validateAuth(ctx.req);
  if (!auth) {
    return {
      redirect: {
        permanent: false,
        destination: "/login",
      },
    };
  }

  const token = (auth as Token).token;

  const { data: transactions } = await makeHttp(token).get("transactions", {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  return {
    props: {
      transactions,
    },
  };
};
