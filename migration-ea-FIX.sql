-- ============================================================
-- FIX : เพิ่มคอลัมน์ EA + สั่ง Supabase รีเฟรช schema cache
-- (แก้ error PGRST204 "Could not find the 'ai_capability_level' column")
-- รันใน Supabase Dashboard → SQL Editor → New query → Run  ทั้งสคริปต์
-- ปลอดภัย รันซ้ำได้ ไม่กระทบข้อมูลเดิม
-- ============================================================

alter table public.responses add column if not exists ea_business        smallint;
alter table public.responses add column if not exists ea_data            smallint;
alter table public.responses add column if not exists ea_application     smallint;
alter table public.responses add column if not exists ea_technology      smallint;
alter table public.responses add column if not exists ea_governance      smallint;
alter table public.responses add column if not exists ea_ai_adoption     smallint;
alter table public.responses add column if not exists ea_total           smallint;
alter table public.responses add column if not exists ea_level           text;
alter table public.responses add column if not exists ai_capability_level text;
alter table public.responses add column if not exists assessment_date    date;

-- ✅ สำคัญ: บังคับให้ PostgREST โหลด schema ใหม่ทันที (แก้ PGRST204)
notify pgrst, 'reload schema';

-- ตรวจผล: ต้องเห็นคอลัมน์ ea_* และ ai_capability_level ครบ
select column_name, data_type
from information_schema.columns
where table_name = 'responses'
  and (column_name like 'ea_%' or column_name in ('ai_capability_level','assessment_date'))
order by column_name;
