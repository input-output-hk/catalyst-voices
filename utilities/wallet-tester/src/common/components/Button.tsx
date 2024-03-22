import type { ButtonHTMLAttributes, ReactNode } from "react";
import { twMerge } from "tailwind-merge";

type Props = {
  children: ReactNode;
} & ButtonHTMLAttributes<HTMLButtonElement>;

function Button({ children, className = "", type = "button", ...props }: Props) {
  return (
    <button
      type={type}
      className={twMerge("bg-primary rounded-md px-4 py-2 text-white", className)}
      {...props}
    >
      {children}
    </button>
  );
}

export default Button;
