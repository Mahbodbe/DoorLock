*🌐 [Read in English](#-smart-door-lock-system-) | 🇮🇷 [برای مطالعه نسخه فارسی کلیک کنید](#-نسخه-فارسی)*

---

# 🚪 Smart Door Lock System 🔐

Welcome to this repository! This project is a smart security and door lock system developed using various electronic modules. The goal of this project is to create a seamless, secure access system featuring user authentication and motion detection.

## 🌟 Features
- **RFID Authentication:** Read, write, and identify cards using the **MFRC522** module.
- **Motion Detection:** Utilize **PIR** sensors to detect human presence near the door.
- **Beam Breaker:** Optical/laser barrier system for tracking entry/exit and providing an extra layer of security.
- **Phased Development:** Independent testing and implementation of each hardware module to ensure stability before final integration.

## 🛠 Hardware & Components
- Microcontroller (Targeted for the specific architecture used in the code)
- MFRC522 RFID Module
- PIR Motion Sensor
- Beam Breaker (Optical/Laser Sensor)
- Relay & Electric Lock (Solenoid Lock / Magnetic Lock)
- Breadboard & Jumper Wires

## 📂 Folder Structure
The project is modularized into separate folders for easier debugging and testing:
- `MFRC522-...` : Initialization, read/write, and self-test codes for the RFID module.
- `PIR-PH1` : Setup and testing for the PIR motion sensor.
- `BeamBreaker-...` : Implementation phases for the beam breaker system.
- `DATASHEET` : Technical documentation and datasheets for the components.
- `PH2-COM` / `PH3-COM` : Communication and final integration phases.

## ⚡ Circuit Diagram & Wiring
> **Work in Progress ⏳** 
> *[Schematic and wiring diagrams for connecting the modules to the microcontroller will be added here soon]*

## 💻 Proteus Simulation
> **Work in Progress ⏳**
> *[Proteus simulation files (.pdsprj) along with screenshots of the working circuit will be uploaded here]*

## 🚀 How to Use
1. Check the `DATASHEET` folder to familiarize yourself with the pinouts and electrical specifications.
2. Wire the components according to the circuit diagram (coming soon).
3. To verify hardware health, compile and upload the individual test files (e.g., `MFRC522-selftest`) to your microcontroller.
4. Flash the final integrated code to get the smart lock system up and running.

## 📌 To-Do List
- [ ] Refactor and clean up the final integrated code.
- [ ] Add the complete circuit schematic.
- [ ] Upload Proteus simulation files.
- [ ] Optimize relay switching and lock response time.

---
---

<a id="نسخه-فارسی"></a>
# 🇮🇷 نسخه فارسی

# 🚪 سیستم قفل در هوشمند (Smart Door Lock) 🔐

به این مخزن خوش آمدید! این پروژه یک سیستم امنیتی و قفل هوشمند است که با استفاده از ماژول‌های الکترونیکی مختلف توسعه داده شده است. هدف این پروژه ایجاد یک سیستم دسترسی یکپارچه و ایمن با قابلیت تشخیص کاربر و حرکت محیطی است.

## 🌟 ویژگی‌های پروژه
- **احراز هویت با RFID:** خواندن، نوشتن و شناسایی کارت‌ها با استفاده از ماژول **MFRC522**.
- **تشخیص حرکت:** استفاده از سنسورهای **PIR** برای تشخیص حضور افراد در نزدیکی در.
- **تشخیص عبور (Beam Breaker):** سیستم نوری/لیزری برای ردیابی عبور و مرور و امنیت مضاعف.
- **توسعه فاز به فاز:** تست و پیاده‌سازی مستقل هر ماژول برای اطمینان از عملکرد صحیح پیش از تجمیع نهایی (کامپوننت‌های تست‌شده).

## 🛠 سخت‌افزارها و قطعات مورد نیاز
- میکروکنترلر (متناسب با معماری کدهای پروژه)
- ماژول RFID مدل MFRC522
- سنسور تشخیص حرکت (PIR Sensor)
- سنسور نوری مانع (Beam Breaker)
- رله و قفل برقی (Solenoid Lock / Magnetic Lock)
- سیم‌کشی و برد بورد

## 📂 ساختار پوشه‌ها
بخش‌های مختلف این پروژه به صورت ماژولار در پوشه‌های مجزا تست و پیاده‌سازی شده‌اند تا عیب‌یابی ساده‌تر باشد:
- `MFRC522-...` : کدهای مربوط به راه‌اندازی، خواندن، نوشتن و تست ماژول RFID.
- `PIR-PH1` : کدهای راه‌اندازی و تست سنسور حرکت.
- `BeamBreaker-...` : پیاده‌سازی فازهای مختلف سنسور تشخیص عبور.
- `DATASHEET` : دیتاشیت‌ها و مستندات فنی قطعات استفاده شده.
- `PH2-COM` / `PH3-COM` : کدهای مربوط به ارتباطات و فازهای تجمیع پروژه.

## ⚡ شماتیک مدار و سیم‌کشی (Circuit Diagram)
> **در حال تکمیل ⏳** 
> *[به زودی عکس و فایل شماتیک مدار برای اتصال صحیح ماژول‌ها به میکروکنترلر در این قسمت قرار می‌گیرد]*

## 💻 شبیه‌سازی پروتئوس (Proteus Simulation)
> **در حال تکمیل ⏳**
> *[به زودی فایل‌های شبیه‌سازی Proteus به همراه اسکرین‌شات عملکرد مدار در محیط شبیه‌ساز در اینجا اضافه خواهد شد]*

## 🚀 نحوه استفاده و راه‌اندازی
1. ابتدا فایل‌های دیتاشیت (`DATASHEET`) را برای آشنایی با پایه‌ها (Pinout) مطالعه کنید.
2. قطعات سخت‌افزاری را طبق شماتیک (که به زودی اضافه می‌شود) متصل کنید.
3. برای اطمینان از سلامت قطعات، می‌توانید فایل‌های تست هر ماژول (مثلاً `MFRC522-selftest`) را به صورت جداگانه کامپایل و روی میکروکنترلر آپلود کنید.
4. فایل اصلی تجمیع‌شده را اجرا کنید تا سیستم قفل هوشمند آماده به کار شود.

## 📌 برنامه‌های آینده (To-Do List)
- [ ] ادغام و تمیزکردن نهایی کدها.
- [ ] اضافه کردن نقشه سیم‌کشی کامل (Circuit Schematic).
- [ ] اضافه کردن فایل پروژه پروتئوس برای شبیه‌سازی نرم‌افزاری.
- [ ] بهینه‌سازی عملکرد رله و پاسخگویی قفل.

---
*ساخته شده با ⚡ و 💻*
