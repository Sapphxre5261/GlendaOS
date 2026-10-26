import Navbar from "../components/Navbar";
import "./globals.css"; // โหลด Tailwind CSS หลัก

// 1. นำเข้าฟอนต์ Lexend จาก next/font/google
import { Lexend } from "next/font/google";

// 2. ตั้งค่าฟอนต์ Lexend (ดึงน้ำหนักตั้งแต่ 100 ถึง 900 ตามที่คุณต้องการ)
const lexend = Lexend({
  weight: ["100", "200", "300", "400", "500", "600", "700", "800", "900"],
  subsets: ["latin"], // ฟอนต์ Lexend รองรับภาษาอังกฤษและละติน
  display: "swap",
});

export default function RootLayout({ children }) {
  return (
    <html lang="th">
      {/* 3. นำ lexend.className มาใส่ร่วมกับคลาสอื่นอย่างถูกต้อง */}
      <body className={`${lexend.className} bg-custom-hero text-slate-100 min-h-screen relative`}>
        
        {/* เลเยอร์กระจกฝ้าสำหรับเบลอรูปพื้นหลังโดยเฉพาะ (อยู่ชั้นหลังสุด ไม่บังเนื้อหา) */}
        <div className="absolute inset-0 backdrop-blur-xl -z-10 fixed" />

        {/* เรียกใช้ Navbar ให้แสดงทุกหน้า */}
        <Navbar />

        {/* เนื้อหาของแต่ละหน้าจะมาแสดงตรง {children} นี้ */}
        <main className="max-w-7xl mx-auto">{children}</main>
        
      </body>
    </html>
  );
}