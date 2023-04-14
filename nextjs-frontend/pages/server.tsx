import { GetServerSideProps } from "next";

export const ServerPage = (props: any) => {
  return <div>Server {props.name}</div>;
};

export const getServerSideProps: GetServerSideProps = async (ctx) => {
  return {
    props: {
      name: "Sidarta Silva",
    },
  };
};

export default ServerPage;
