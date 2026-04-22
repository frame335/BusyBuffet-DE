# 1. กำหนดโฟลเดอร์ที่เก็บไฟล์
$folderPath = "D:\DBT\DBT\data-atmind-test"

# 2. ดึงรายชื่อไฟล์ .csv ทั้งหมดในโฟลเดอร์นั้นออกมา
$files = Get-ChildItem -Path $folderPath -Filter "*.csv"

foreach ($file in $files) {
    try {
        $inputFile = $file.FullName
        
        # ดึงชื่อไฟล์ (ไม่เอา .csv) เพื่อใช้ในคอลัมน์ source_name
        $fileNameOnly = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)

        # 3. อ่านข้อมูลทั้งหมดเข้าสู่ตัวแปร (ต้องทำแบบนี้ถึงจะเซฟทับไฟล์เดิมได้)
        # เราใส่ ( ) ครอบคำสั่ง Import-Csv เพื่อให้มันอ่านจนจบและปิดไฟล์ทันที
        $data = (Import-Csv -Path $inputFile -Delimiter ',' -Encoding UTF8)

        # 4. เพิ่มคอลัมน์ source_name และเขียนทับไฟล์เดิมด้วยตัวคั่น |
        $data | Select-Object *, @{Name="source_name"; Expression={$fileNameOnly}} | 
        Export-Csv -Path $inputFile -Delimiter '|' -NoTypeInformation -Encoding UTF8

        Write-Host "สำเร็จ: [$($file.Name)] เพิ่มคอลัมน์และแปลงเป็น Pipe เรียบร้อย" -ForegroundColor Green
    }
    catch {
        Write-Host "ผิดพลาด: ไม่สามารถจัดการไฟล์ $($file.Name) ได้เนื่องจาก: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n--- ทำงานเสร็จสิ้นทุกไฟล์แล้ว ---" -ForegroundColor Yellow