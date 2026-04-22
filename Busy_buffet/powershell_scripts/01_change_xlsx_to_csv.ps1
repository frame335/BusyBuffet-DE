
# แก้ Path ให้ตรงกับโฟลเดอร์ใหม่ที่ชื่อ data-atmind-test
$excelFile = "D:\DBT\DBT\data-atmind-test\2026 Data Test1 Final - Busy Buffet Dataset.xlsx"
$outputFolder = "D:\DBT\DBT\data-atmind-test"

# ตรวจสอบโฟลเดอร์
if (!(Test-Path $outputFolder)) { New-Item -ItemType Directory -Path $outputFolder }

# ดึงรายชื่อ Sheet
$sheets = Get-ExcelSheetInfo -Path $excelFile

foreach ($sheet in $sheets) {
    $name = $sheet.Name
    $outputPath = Join-Path $outputFolder "$name.csv"
    
    # แก้ไขตรงนี้: เติม * หลัง -AsText เพื่อบอกว่าเอาทุก Column เป็น Text
    Import-Excel -Path $excelFile -WorksheetName $name -AsText * | 
    Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8
    
    Write-Host "สำเร็จ! แปลง Sheet [$name] เรียบร้อยแล้ว" -ForegroundColor Green
}

Write-Host "`nกระบวนการทั้งหมดเสร็จสิ้นแล้ว!" -ForegroundColor Yellow -BackgroundColor DarkBlue