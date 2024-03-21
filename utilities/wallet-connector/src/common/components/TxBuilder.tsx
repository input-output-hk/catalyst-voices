import { useForm } from "react-hook-form";

import { BASE_INPUT_STYLE } from "common/constants";

type FormValues = {
  regAddress: string;
  regAmount: string;
  regText: string;
  regLabel: string;
  stakeCred: string;
};

type Props = {

};

function TxBuilder({ }: Props) {
  const { handleSubmit, register } = useForm<FormValues>({
    defaultValues: {

    }
  });

  async function onSubmit(formValues: FormValues) {

  }

  return (
    <form className="grid gap-2" onSubmit={handleSubmit(onSubmit)}>
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
        placeholder="registration text"
        {...register("regText")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration label"
        {...register("regLabel")}
      />
    </form>
  );
}

export default TxBuilder;