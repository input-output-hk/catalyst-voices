import { useId, type InputHTMLAttributes } from "react";
import type { UseFormRegisterReturn } from "react-hook-form";

type Props = {
  label: string;
  formRegister?: UseFormRegisterReturn;
} & InputHTMLAttributes<HTMLInputElement>;

function Input({ label, formRegister, ...props }: Props) {
  const id = useId();

  return (
    <div className="relative">
      <input
        type="text"
        id={id}
        className="w-full rounded-md border border-solid border-black/10 p-2 truncate"
        {...props}
        {...formRegister}
      />
      <label
        htmlFor={id}
        className="absolute text-sm text-gray-500 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1"
      >
        {label}
      </label>
    </div>
  );
}

export default Input;
