# 1. กำหนดค่าพื้นฐาน
$csvPath = "D:\DBT\DBT\data-atmind-test\183.csv"
$serverName = ".\SQLEXPRESS" 
$databaseName = "test"
$tableName = "fact_queue"
$schemaName = "staging"

# 2. อ่านข้อมูลจาก CSV โดยใช้ตัวคั่นเป็น | (Pipe)
# ถ้าไฟล์ต้นทางใช้ | ต้องระบุแบบนี้ครับ
$rawData = Import-Csv -Path $csvPath -Delimiter '|' -Encoding UTF8

# 3. ขั้นตอนการ Clean ข้อมูล (ลบคอมม่าในตัวเลข)
$cleanedData = foreach ($row in $rawData) {
    # สร้าง Object ใหม่เพื่อเก็บค่าที่ล้างแล้ว
    $newRow = $row | Select-Object *
    
    # วนลูปเช็คทุกคอลัมน์ในแถวนั้นๆ
    foreach ($prop in $row.PSObject.Properties.Name) {
        $val = $row.$prop
        
        # ถ้าค่ามีคอมม่าปนกับตัวเลข (เช่น 1,200.50) ให้ลบคอมม่าออก
        # ใช้ Regex ตรวจสอบว่ามีคอมม่าระหว่างตัวเลขหรือไม่
        if ($val -match '^\d{1,3}(,\d{3})*(\.\d+)?$') {
            $newRow.$prop = $val.Replace(',', '')
        }
    }
    $newRow
}

# 4. นำข้อมูลที่ Clean แล้วเข้าสู่ SQL
try {
    Write-SqlTableData -ServerInstance $serverName -DatabaseName $databaseName -SchemaName $schemaName -TableName $tableName -InputData $cleanedData -Force
    Write-Host "ล้างข้อมูลและนำเข้าสำเร็จแล้ว!" -ForegroundColor Green
}
catch {
    Write-Host "เกิดข้อผิดพลาด: $($_.Exception.Message)" -ForegroundColor Red
}