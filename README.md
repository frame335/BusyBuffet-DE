# 🍱 Busy Buffet: End-to-End Data Pipeline & Analytics

โปรเจกต์นี้เป็นการจำลองระบบจัดการข้อมูลร้านอาหาร Buffet ตั้งแต่การทำ Automation ในการเตรียมข้อมูล (ETL) ไปจนถึงการทำ Data Modeling ด้วย dbt และนำเสนอผ่าน Power BI Dashboard

## 🛠️ Tech Stack
* **Automation:** PowerShell Scripts
* **Database:** SQL Server
* **Transformation:** dbt (Data Build Tool)
* **Visualization:** Power BI
* **Analysis:** Stata (Field Data Survey)

---

## 📂 Project Structure
* `automation_scripts/`: ไฟล์ PowerShell (.ps1) สำหรับแปลงข้อมูลจาก Excel เป็น CSV และนำเข้า SQL Server อัตโนมัติ
* `data_transformation/`: dbt project ที่ใช้ในการ Clean, Transform และจัดการ Data Mart
* `raw_data/`: ข้อมูลตัวอย่างที่ใช้ในโปรเจกต์ (Sample Data)
* `documentation/`: ไฟล์ Presentation และไฟล์ Power BI (.pbix)
* `sql_schema/`: (ถ้ามี) ไฟล์ SQL สำหรับการสร้าง Table เริ่มต้น

---

## 🚀 Workflow
1. **Data Extraction & Loading:** ใช้ PowerShell ในการดึงข้อมูลจากหลายๆ Sheet ใน Excel ออกมาเป็น CSV และ Load เข้าสู่ SQL Server (Staging Area)
2. **Data Transformation:** ใช้ dbt ในการทำ Data Modeling:
   * **Staging:** ปรับ Data Type และจัดการค่าว่าง
   * **Marts:** สร้าง Fact Table และ Dimension สำหรับการวิเคราะห์ (เช่น `cleaned_fact_queue`)
3. **Data Analysis & Visualization:** นำข้อมูลที่ Clean แล้วจาก SQL Server มาทำ Dashboard ใน Power BI เพื่อดู Insight ของร้านอาหาร

---

## 📊 Key Highlights
* **Automation:** ลดเวลาการทำงาน Manual โดยการใช้ PowerShell จัดการไฟล์และ Database
* **dbt Integration:** มีการใช้ Version Control และ Modular SQL ในการจัดการ Transformation Logic
* **End-to-End Pipeline:** แสดงทักษะการจัดการข้อมูลตั้งแต่ต้นน้ำจนถึงปลายน้ำ

---

## 👨‍💻 Author
**Peerapat Sorotsokchai (พีรภัทร์ โสฬสโชคชัย)**
* Computer Science Student, Ramkhamhaeng University
* Interested in Data Engineering, Software Architecture, and Image Processing
