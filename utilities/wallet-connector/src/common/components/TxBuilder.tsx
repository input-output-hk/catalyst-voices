import { noop } from "lodash-es";
import { useForm } from "react-hook-form";

import { BASE_INPUT_STYLE } from "common/constants";
import type { TxBuilderArguments } from "types/cardano";

import Button from "./Button";

type FormValues = TxBuilderArguments;

type Props = {
  onSubmit?: (value: FormValues) => void;
};

function TxBuilder({ onSubmit: onPropSubmit = noop }: Props) {
  const { handleSubmit, register, reset } = useForm<FormValues>({
    defaultValues: {},
  });

  function handleReset() {
    reset();
  }

  async function onSubmit(formValues: FormValues) {
    onPropSubmit(formValues);
  }

  return (
    <form className="grid gap-2" autoComplete="off">
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration address"
        {...register("regAddress")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration amount"
        {...register("regAmount")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration label"
        {...register("regLabel")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration text"
        {...register("regText")}
      />
      <div className="flex gap-2">
        <Button className="w-fit" onClick={handleSubmit(onSubmit)}>
          <p>Build</p>
        </Button>
        <Button className="w-fit" onClick={handleReset}>
          <p>Clear</p>
        </Button>
      </div>
    </form>
  );
}

export default TxBuilder;
