declare module "http" {
  interface IncomingMessage {
    subdomain?: string;
  }
}
