-- CreateTable
CREATE TABLE "app_support_config" (
    "id" TEXT NOT NULL,
    "developer_name" TEXT,
    "developer_title" TEXT,
    "developer_bio" TEXT,
    "support_email" TEXT,
    "support_phone" TEXT,
    "support_whatsapp" TEXT,
    "help_video_url" TEXT,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by_developer_sub" TEXT,

    CONSTRAINT "app_support_config_pkey" PRIMARY KEY ("id")
);

-- Seed default support config row (published by default).
INSERT INTO "app_support_config" (
  "id",
  "developer_name",
  "developer_title",
  "developer_bio",
  "support_email",
  "support_phone",
  "support_whatsapp",
  "help_video_url",
  "is_published",
  "updated_at"
)
VALUES (
  'default',
  'Mohammad Afzal Akbari',
  'Developer & owner',
  'Software engineer (graduated from India).',
  'afzalakbari2017@gmail.com',
  '0788995093',
  '0788995093',
  NULL,
  true,
  CURRENT_TIMESTAMP
)
ON CONFLICT ("id") DO NOTHING;

