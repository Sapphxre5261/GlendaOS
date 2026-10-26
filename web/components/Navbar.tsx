import Link from "next/link";
import Image from "next/image";

export default function Navbar() {
  return (
    // ปรับเปลี่ยน bg-stlte-700 เป็น bg-slate-950/60 หรือ bg-black/40 (เข้มขึ้น สวยหรู แต่ยังเห็นฉากหลังเบลอ)
    <nav className="bg-black/40 text-white w-full sticky top-0 z-50 backdrop-blur-md border-b border-slate-800/40 px-4">

      <div className="flex justify-between items-center max-w-7xl w-full mx-auto py-2">

        <div className="flex gap-2 items-center">
          <Image
            src="/G-icon-removebg.png"
            alt="โลโก้ SVG"
            width={50}
            height={50}
            className="text-white"
          />
          <div className="text-white font-sans text-xl font-bold">
            Glenda
          </div>
        </div>

        <div className="flex gap-6 text-neutral-300 font-medium text-base">
          <Link href="/" className="hover:text-white transition-colors">
            Home
          </Link>
          <Link href="/playbook" className="hover:text-white transition-colors">
            Playbook
          </Link>
          <Link href="/programs" className="hover:text-white transition-colors">
            Programs
          </Link>
          <Link href="/about" className="hover:text-white transition-colors">
            Documentation
          </Link>
          <Link href="/about" className="hover:text-white transition-colors">
            About
          </Link>
        </div>

        <div className="flex gap-4 items-center">
          <div>
            <Link
              href="https://github.com/Sapphxre5261"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:opacity-80 transition-opacity block"
            >
              <Image
                src="/github-white-icon.svg"
                alt="GitHub Icon"
                width={30}
                height={30}
                className="text-white"
              />
            </Link>
          </div>

          <div>
            <Image
              src="/discord-round-color-icon.svg"
              alt="Discord Icon"
              width={30}
              height={30}
              className="text-white cursor-pointer hover:opacity-80 transition-opacity"
            />
          </div>
        </div>

      </div>

    </nav>
  );
}