-- CreateEnum
CREATE TYPE "public"."adminRole" AS ENUM ('SUPERADMIN', 'ADMIN');

-- CreateEnum
CREATE TYPE "public"."roomSection" AS ENUM ('SS1', 'SS2');

-- CreateEnum
CREATE TYPE "public"."paymentMethod" AS ENUM ('CASH', 'TRANSFER', 'PROMPTPAY', 'CREDIT_CARD', 'OTHER');

-- CreateTable
CREATE TABLE "public"."resident" (
    "id" SERIAL NOT NULL,
    "prefix" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "chaya" TEXT NOT NULL,
    "tel" TEXT NOT NULL,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "resident_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."room" (
    "id" SERIAL NOT NULL,
    "section" "public"."roomSection" NOT NULL,
    "floor" INTEGER NOT NULL,
    "room_no" INTEGER NOT NULL,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."residentStay" (
    "id" SERIAL NOT NULL,
    "residentId" INTEGER NOT NULL,
    "roomId" INTEGER NOT NULL,
    "movedInAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "movedOutAt" TIMESTAMP(3),
    "note" TEXT,

    CONSTRAINT "residentStay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."meter" (
    "id" SERIAL NOT NULL,
    "metor_no" INTEGER NOT NULL,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "meter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."roomMeter" (
    "roomId" INTEGER NOT NULL,
    "metorId" INTEGER NOT NULL,
    "installedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "removedAt" TIMESTAMP(3),

    CONSTRAINT "roomMeter_pkey" PRIMARY KEY ("roomId","metorId")
);

-- CreateTable
CREATE TABLE "public"."administrater" (
    "id" SERIAL NOT NULL,
    "residentId" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "public"."adminRole" NOT NULL DEFAULT 'ADMIN',
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "administrater_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."config" (
    "id" SERIAL NOT NULL,
    "electricity_rate" DECIMAL(10,4) NOT NULL,
    "internet_fee" DECIMAL(10,2) NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" TEXT,
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "config_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."internetCharge" (
    "id" SERIAL NOT NULL,
    "residentStayId" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "period_start" TIMESTAMP(3),
    "period_end" TIMESTAMP(3),
    "amount" DECIMAL(10,2) NOT NULL,
    "due_date" TIMESTAMP(3),
    "isPaid" BOOLEAN NOT NULL DEFAULT false,
    "paid_at" TIMESTAMP(3),
    "note" TEXT,
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "internetCharge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."internetPayment" (
    "id" SERIAL NOT NULL,
    "chargeId" INTEGER NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "method" "public"."paymentMethod" NOT NULL,
    "paidAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "recordedById" INTEGER,
    "note" TEXT,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "internetPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."internetUserMonth" (
    "id" SERIAL NOT NULL,
    "residentStayId" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "activatedAt" TIMESTAMP(3),
    "note" TEXT,
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "time_create" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_stamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "internetUserMonth_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "residentStay_residentId_movedOutAt_idx" ON "public"."residentStay"("residentId", "movedOutAt");

-- CreateIndex
CREATE INDEX "residentStay_roomId_movedOutAt_idx" ON "public"."residentStay"("roomId", "movedOutAt");

-- CreateIndex
CREATE UNIQUE INDEX "residentStay_residentId_movedInAt_key" ON "public"."residentStay"("residentId", "movedInAt");

-- CreateIndex
CREATE INDEX "roomMeter_roomId_removedAt_idx" ON "public"."roomMeter"("roomId", "removedAt");

-- CreateIndex
CREATE INDEX "roomMeter_metorId_removedAt_idx" ON "public"."roomMeter"("metorId", "removedAt");

-- CreateIndex
CREATE UNIQUE INDEX "administrater_username_key" ON "public"."administrater"("username");

-- CreateIndex
CREATE UNIQUE INDEX "administrater_residentId_key" ON "public"."administrater"("residentId");

-- CreateIndex
CREATE INDEX "config_effective_from_idx" ON "public"."config"("effective_from");

-- CreateIndex
CREATE INDEX "internetCharge_residentStayId_year_month_idx" ON "public"."internetCharge"("residentStayId", "year", "month");

-- CreateIndex
CREATE INDEX "internetCharge_due_date_idx" ON "public"."internetCharge"("due_date");

-- CreateIndex
CREATE UNIQUE INDEX "internetCharge_residentStayId_year_month_key" ON "public"."internetCharge"("residentStayId", "year", "month");

-- CreateIndex
CREATE INDEX "internetPayment_chargeId_paidAt_idx" ON "public"."internetPayment"("chargeId", "paidAt");

-- CreateIndex
CREATE INDEX "internetUserMonth_year_month_idx" ON "public"."internetUserMonth"("year", "month");

-- CreateIndex
CREATE INDEX "internetUserMonth_residentStayId_idx" ON "public"."internetUserMonth"("residentStayId");

-- CreateIndex
CREATE UNIQUE INDEX "internetUserMonth_residentStayId_year_month_key" ON "public"."internetUserMonth"("residentStayId", "year", "month");

-- AddForeignKey
ALTER TABLE "public"."residentStay" ADD CONSTRAINT "residentStay_residentId_fkey" FOREIGN KEY ("residentId") REFERENCES "public"."resident"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."residentStay" ADD CONSTRAINT "residentStay_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "public"."room"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."roomMeter" ADD CONSTRAINT "roomMeter_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "public"."room"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."roomMeter" ADD CONSTRAINT "roomMeter_metorId_fkey" FOREIGN KEY ("metorId") REFERENCES "public"."meter"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."administrater" ADD CONSTRAINT "administrater_residentId_fkey" FOREIGN KEY ("residentId") REFERENCES "public"."resident"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."config" ADD CONSTRAINT "config_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."config" ADD CONSTRAINT "config_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetCharge" ADD CONSTRAINT "internetCharge_residentStayId_fkey" FOREIGN KEY ("residentStayId") REFERENCES "public"."residentStay"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetCharge" ADD CONSTRAINT "internetCharge_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetCharge" ADD CONSTRAINT "internetCharge_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetPayment" ADD CONSTRAINT "internetPayment_chargeId_fkey" FOREIGN KEY ("chargeId") REFERENCES "public"."internetCharge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetPayment" ADD CONSTRAINT "internetPayment_recordedById_fkey" FOREIGN KEY ("recordedById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetUserMonth" ADD CONSTRAINT "internetUserMonth_residentStayId_fkey" FOREIGN KEY ("residentStayId") REFERENCES "public"."residentStay"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetUserMonth" ADD CONSTRAINT "internetUserMonth_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."internetUserMonth" ADD CONSTRAINT "internetUserMonth_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "public"."administrater"("id") ON DELETE SET NULL ON UPDATE CASCADE;
