import {
  buildMessage,
  registerDecorator,
  ValidationArguments,
  ValidationOptions,
} from "class-validator";
import { parseISO } from "date-fns";

export function IsAfter(field: any, validationOptions?: ValidationOptions) {
  return function (object: any, propertyName: string) {
    registerDecorator({
      name: "IsAfter",
      constraints: [field],
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(value: any, args: ValidationArguments) {
          return parseISO(value) > parseISO(args.object[args.constraints[0]]);
        },
        defaultMessage: buildMessage(
          (eachPrefix: string, args: ValidationArguments) =>
            `${eachPrefix}${args.constraints[0]}`,
          validationOptions
        ),
      },
    });
  };
}
