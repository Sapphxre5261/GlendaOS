export default function Home() {
  return (
    <div className="p-8 text-center min-h-screen">

      <h1 className="text-9xl font-bold">
        Glenda
      </h1>
      <h2 className="text-4xl font-bold text-red-700 pt-6">
        A Non-Profit Project
      </h2>
      <h2 className="text-2xl font-bold text-white">
        Free & Open Source
      </h2>

      <p className="text-xl text-slate-300 max-w-2xl mx-auto font-light pt-20">
        Say goodbye to bloat, hello to a smooth Windows.
      </p>

      <p>
      </p>

      {/* <div className="grid grid-cols-3 gap-4 pt-20">
        <div>
          Open & Transparent
        </div>
        <div>
          Safe & Clean
        </div>
        <div>
          Privacy-First
        </div>
      </div> */}

      <h2 className="text-4xl text-bold">
        What Glenda Does
      </h2>


      <div className="grid grid-cols-2 gap-4 pt-20 max-w-4xl mx-auto">

        <div className="bg-slate-500">
          <h2>
            GlendaOS
          </h2>
          <p>
            GlendaOS transforms standard Windows into a clean, responsive OS by delivering a custom-built Playbook for the AME Wizard framework.
          </p>
        </div>

        <div>
          Programs
        </div>


      </div>
    </div>
  );
}