{{ config(
    materialized='table',
    schema='mart'
) }}

with raw_data as (
    select * from {{ source('staging', 'fact_queue') }}
),

cleaned as (
    select
        try_cast(nullif(service_no, '') as int) as service_no,
        try_cast(nullif(pax, '') as int) as pax,
        cast(nullif(table_no, '') as nvarchar(10)) as table_no,
        
        try_cast(nullif(queue_start, '') as time(0)) as queue_start,
        try_cast(nullif(queue_end, '') as time(0)) as queue_end,
        
        -- Logic: สลับค่าเฉพาะ service_no 62 และ source_name 183
        case 
            when try_cast(nullif(service_no, '') as int) = 62 
                 and cast(nullif(source_name, '') as nvarchar(50)) = '183'
            then try_cast(nullif(meal_end, '') as time(0)) 
            else try_cast(nullif(meal_start, '') as time(0)) 
        end as meal_start,

        case 
            when try_cast(nullif(service_no, '') as int) = 62 
                 and cast(nullif(source_name, '') as nvarchar(50)) = '183'
            then try_cast(nullif(meal_start, '') as time(0)) 
            else try_cast(nullif(meal_end, '') as time(0)) 
        end as meal_end,
        
        cast(nullif(guest_type, '') as nvarchar(50)) as guest_type,
        cast(nullif(source_name, '') as nvarchar(50)) as source_name
    from raw_data
)

select 
    *
from cleaned
where service_no is not null 
  and pax is not null
  and pax > 0
  and not (queue_start is null and queue_end is null and meal_start is null and meal_end is null)