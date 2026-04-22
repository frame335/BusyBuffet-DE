{{ config(
    materialized='view',
    schema='semantic'
) }}

WITH base_data AS (
    SELECT 
        guest_type,
        service_no,
        -- แปลงเวลาล่วงหน้าเพื่อลดความซับซ้อนในขั้นถัดไป
        TRY_CAST(meal_start AS DATETIME) as m_start,
        TRY_CAST(meal_end AS DATETIME) as m_end,
        TRY_CAST(queue_start AS DATETIME) as q_start,
        TRY_CAST(queue_end AS DATETIME) as q_end
    FROM {{ ref('cleaned_fact_queue') }}
),
metrics AS (
    SELECT 
        guest_type,
        service_no,
        DATEDIFF(MINUTE, m_start, m_end) AS meal_duration,
        -- Logic: มีคิวแต่ไม่มีเวลานั่งทาน = Walk-away [cite: 102]
        CASE 
            WHEN q_start IS NOT NULL AND m_start IS NULL THEN 1 
            ELSE 0 
        END AS is_walk_away,
        -- Logic: กลุ่มที่ต้องรอคิว [cite: 116]
        CASE 
            WHEN q_start IS NOT NULL THEN 1 
            ELSE 0 
        END AS had_to_queue
    FROM base_data
)
SELECT 
    guest_type,
    COUNT(service_no) AS total_groups,
    SUM(had_to_queue) AS total_queuing_groups,
    SUM(is_walk_away) AS total_walk_away,
    -- คำนวณค่าเฉลี่ยโดยข้ามค่า NULL
    AVG(CAST(meal_duration AS FLOAT)) AS avg_meal_duration_mins,
    -- คำนวณ Walk-away Rate [cite: 102]
    CAST(
        SUM(is_walk_away) * 100.0 / NULLIF(SUM(had_to_queue), 0) 
    AS DECIMAL(10,2)) AS walk_away_rate_pct
FROM metrics
GROUP BY guest_type

-- การหาสัดส่วนใน power bi