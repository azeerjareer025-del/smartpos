# SmartPOS — Professional Retail POS & Inventory System

This is the V2 single-shop SmartPOS project requested in the master specification.

## Stack
- Next.js App Router
- Supabase PostgreSQL/Auth-ready architecture
- Vercel-ready
- Responsive desktop/mobile UI
- LKR/Rs currency

## Modules
Dashboard, POS, Inventory, Categories, Suppliers, Purchases, Sales History,
Customers/Credit, Expenses, Reports, Settings and User Roles.

## Important production setup
The source contains a complete PostgreSQL schema and the UI foundation. To make
the data cloud-synchronized between iPhone and computers, create a Supabase
project, run `supabase/schema.sql`, then put the Supabase URL/key into
`.env.local` and Vercel Environment Variables.

Do not put the Supabase service-role key in browser/client code.

## Run
npm install
npm run dev

## Vercel
Push the folder to GitHub, import the repository in Vercel, and add the two
NEXT_PUBLIC_SUPABASE_* variables. Add the service key only as a server-side
secret if server-side admin operations are implemented.

## Production transaction requirement
Complete-sale, refund and purchase-receiving operations should use database
transactions/RPCs so inventory cannot become inconsistent.
