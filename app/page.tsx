export default function Home() {
  return (
    <main className="min-h-screen bg-[#071b13] text-white">
      <header className="border-b border-white/10 px-6 py-5">
        <div className="mx-auto flex max-w-5xl items-center gap-3">
          <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-600 text-xl font-bold">
            GH
          </div>
          <div>
            <h1 className="text-lg font-bold tracking-wide">GREEN HOUSE</h1>
            <p className="text-xs text-emerald-300">SPORTS & CULTURAL PORTAL</p>
          </div>
        </div>
      </header>

      <section className="mx-auto max-w-5xl px-6 py-16">
        <p className="mb-4 text-sm font-semibold tracking-[0.25em] text-emerald-400">
          REV. WILLIAM WARD SENIOR SECONDARY SCHOOL
        </p>

        <h2 className="text-4xl font-black leading-tight sm:text-6xl">
          UNITED IN STRENGTH.
          <span className="block text-emerald-400">
            UNSTOPPABLE IN SPIRIT.
          </span>
        </h2>

        <p className="mt-6 max-w-2xl leading-7 text-gray-300">
          Welcome to the Green House Sports and Cultural Participation Portal.
          Explore events, register your participation and be part of the spirit
          of Green House.
        </p>

        <div className="mt-10 grid gap-4 sm:grid-cols-2">
          <div className="rounded-2xl border border-emerald-500/20 bg-white/5 p-6">
            <p className="text-sm text-emerald-300">STUDENT PORTAL</p>
            <h3 className="mt-3 text-2xl font-bold">Event Registration</h3>
            <p className="mt-3 text-sm leading-6 text-gray-300">
              Student participation registration for sports and cultural events
              will be available here.
            </p>
            <button
              disabled
              className="mt-6 w-full rounded-xl bg-emerald-700 px-5 py-3 font-semibold text-white opacity-70"
            >
              Registration Coming Soon
            </button>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/5 p-6">
            <p className="text-sm text-amber-300">MANAGEMENT</p>
            <h3 className="mt-3 text-2xl font-bold">House Dashboard</h3>
            <p className="mt-3 text-sm leading-6 text-gray-300">
              Management access for authorised House leaders, volunteers and
              teachers.
            </p>
            <button
              disabled
              className="mt-6 w-full rounded-xl border border-white/20 px-5 py-3 font-semibold text-white opacity-70"
            >
              Management Login Coming Soon
            </button>
          </div>
        </div>

        <div className="mt-12 rounded-2xl bg-emerald-950/60 p-6 text-center">
          <p className="text-sm tracking-widest text-emerald-300">
            GREEN HOUSE
          </p>
          <p className="mt-2 text-lg font-semibold">
            United in Strength. Unstoppable in Spirit.
          </p>
        </div>
      </section>

      <footer className="border-t border-white/10 px-6 py-6 text-center text-xs text-gray-400">
        REV. WILLIAM WARD SENIOR SECONDARY SCHOOL · GREEN HOUSE
      </footer>
    </main>
  );
}
