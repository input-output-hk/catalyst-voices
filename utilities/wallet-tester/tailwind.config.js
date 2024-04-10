/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#35cac1",
        secondary: "#8caee1",
        background: "#f9fdfd",
        text: "#051111",
        accent: "#6775d7"
      }
    },
  },
  plugins: [],
}
