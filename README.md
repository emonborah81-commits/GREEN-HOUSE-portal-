# Green House — Sports & Cultural Participation Portal

Next.js / TypeScript / Tailwind / Supabase starter implementation, mobile-first.

## Run locally
1. Install Node.js 20+ on a computer (or use GitHub Codespaces).
2. `npm install`
3. Copy `.env.example` to `.env.local`, and fill Supabase URL and anon key.
4. Run `npm run dev` and open `http://localhost:3000`.

## Supabase setup
1. Create a Supabase project.
2. In SQL Editor, run the contents of `supabase/schema.sql`.
3. In Authentication, create management accounts for school-approved staff only. Do not publish or share passwords.
4. In SQL Editor, assign each staff user a role (replace the UUID):
   `insert into public.management_profiles(id,role) values('AUTH_USER_UUID','captain');`
   Valid roles: `captain`, `vice_captain`, `volunteer`, `teacher`.
5. Add `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` to `.env.local` and Vercel project settings.
6. Set registration status using captain/vice-captain login after role is assigned.

## Environment variables
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` (public anon key; RLS protects data)

Never add a Supabase service-role key to this frontend project.

## GitHub and Vercel
Upload the project directory to a GitHub repository, then import that repository into Vercel. Select the root directory and add the two environment variables. Vercel builds using `npm run build`.

## Current scope / limitations
Student registration, registration status, event selection, management login, basic manager roster and CSV export are implemented. The SQL provides role policies and database foundations. Event editing, detailed event-participant exports, charts, configurable teacher permissions, robust audit triggers, rate limiting and edit/delete roster UI remain to be implemented before real school use. The SQL should be reviewed and tested by a responsible school administrator before publishing. The frontend deliberately does not expose student records to unauthenticated visitors.
