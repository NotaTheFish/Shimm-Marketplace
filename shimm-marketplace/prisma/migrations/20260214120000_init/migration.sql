-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('active', 'frozen', 'banned', 'deleted');

-- CreateEnum
CREATE TYPE "FraudReputationLabel" AS ENUM ('clean', 'suspicious', 'warned', 'scam_reports_present', 'restricted', 'banned_for_fraud');

-- CreateEnum
CREATE TYPE "SystemRole" AS ENUM ('owner', 'admin', 'moderator', 'support');

-- CreateEnum
CREATE TYPE "DealState" AS ENUM ('created', 'pending_seller_review', 'seller_accepted', 'seller_declined', 'secret_chat_created', 'waiting_participants_join', 'active', 'guarantor_requested', 'guarantor_invited', 'guarantor_joined', 'scam_reported', 'admin_review', 'disputed', 'completion_requested', 'completion_confirmed_by_client', 'completion_confirmed_partial', 'completion_confirmed_full', 'feedback_phase', 'close_requested', 'closed', 'force_closed', 'archived');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('new', 'pending_seller', 'accepted', 'declined', 'no_longer_relevant', 'expired', 'disputed');

-- CreateEnum
CREATE TYPE "LedgerAccountKind" AS ENUM ('user_available', 'user_reserved', 'user_bonus', 'system_revenue', 'system_fee', 'escrow', 'dispute_hold');

-- CreateEnum
CREATE TYPE "LedgerLineSide" AS ENUM ('debit', 'credit');

-- CreateEnum
CREATE TYPE "WithdrawalStatus" AS ENUM ('pending', 'processing', 'completed', 'failed', 'cancelled');

-- CreateEnum
CREATE TYPE "GameSlug" AS ENUM ('dragon_adventures', 'creatures_of_sonaria');

-- CreateEnum
CREATE TYPE "SupportTicketStatus" AS ENUM ('open', 'pending', 'closed');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "telegram_user_id" BIGINT NOT NULL,
    "username" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "language_code" TEXT,
    "region" TEXT,
    "status" "UserStatus" NOT NULL DEFAULT 'active',
    "kyc_level" INTEGER NOT NULL DEFAULT 0,
    "trust_score" DECIMAL(12,4) NOT NULL DEFAULT 0,
    "risk_score" DECIMAL(12,4) NOT NULL DEFAULT 0,
    "fraud_label" "FraudReputationLabel" NOT NULL DEFAULT 'clean',
    "fraud_report_count" INTEGER NOT NULL DEFAULT 0,
    "confirmed_fraud_count" INTEGER NOT NULL DEFAULT 0,
    "abuse_reports_false" INTEGER NOT NULL DEFAULT 0,
    "last_seen_at" TIMESTAMP(3),
    "is_seller" BOOLEAN NOT NULL DEFAULT false,
    "is_guarantor" BOOLEAN NOT NULL DEFAULT false,
    "is_admin" BOOLEAN NOT NULL DEFAULT false,
    "is_moderator" BOOLEAN NOT NULL DEFAULT false,
    "can_create_orders" BOOLEAN NOT NULL DEFAULT true,
    "can_accept_orders" BOOLEAN NOT NULL DEFAULT true,
    "can_join_secret_chats" BOOLEAN NOT NULL DEFAULT true,
    "seller_not_accepting_requests" BOOLEAN NOT NULL DEFAULT false,
    "ignored_requests_count" INTEGER NOT NULL DEFAULT 0,
    "response_rate_percent" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserRole" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role" "SystemRole" NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminUser" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profile" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "bio" TEXT,
    "roblox_user_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RobloxVerification" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "roblox_user_id" TEXT NOT NULL,
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RobloxVerification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Deal" (
    "id" TEXT NOT NULL,
    "state" "DealState" NOT NULL DEFAULT 'created',
    "client_id" TEXT NOT NULL,
    "seller_id" TEXT NOT NULL,
    "guarantor_id" TEXT,
    "title" TEXT NOT NULL,
    "category" TEXT,
    "budget_minor" BIGINT NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'SHIMM',
    "needs_guarantor" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Deal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealEvent" (
    "id" TEXT NOT NULL,
    "deal_id" TEXT NOT NULL,
    "actor_id" TEXT,
    "type" TEXT NOT NULL,
    "payload" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DealEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealChat" (
    "id" TEXT NOT NULL,
    "deal_id" TEXT NOT NULL,
    "telegram_chat_id" BIGINT,
    "join_window_ends_at" TIMESTAMP(3),
    "destroyed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DealChat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealInvite" (
    "id" TEXT NOT NULL,
    "deal_chat_id" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "invite_link" TEXT NOT NULL,
    "nonce" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DealInvite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealApplication" (
    "id" TEXT NOT NULL,
    "deal_id" TEXT,
    "client_id" TEXT NOT NULL,
    "seller_id" TEXT NOT NULL,
    "status" "ApplicationStatus" NOT NULL DEFAULT 'new',
    "title" TEXT NOT NULL,
    "description" TEXT,
    "budget_minor" BIGINT NOT NULL DEFAULT 0,
    "deadline_at" TIMESTAMP(3),
    "needs_guarantor" BOOLEAN NOT NULL DEFAULT false,
    "seller_responded_at" TIMESTAMP(3),
    "notify_on_response" BOOLEAN NOT NULL DEFAULT false,
    "idempotency_key" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DealApplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Review" (
    "id" TEXT NOT NULL,
    "deal_id" TEXT NOT NULL,
    "author_id" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Wallet" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'SHIMM',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Wallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerAccount" (
    "id" TEXT NOT NULL,
    "wallet_id" TEXT NOT NULL,
    "kind" "LedgerAccountKind" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerJournal" (
    "id" TEXT NOT NULL,
    "idempotency_key" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerJournal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerLine" (
    "id" TEXT NOT NULL,
    "journal_id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "side" "LedgerLineSide" NOT NULL,
    "amount_minor" BIGINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Withdrawal" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "amount_minor" BIGINT NOT NULL,
    "status" "WithdrawalStatus" NOT NULL DEFAULT 'pending',
    "idempotency_key" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Withdrawal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Listing" (
    "id" TEXT NOT NULL,
    "seller_id" TEXT NOT NULL,
    "game" "GameSlug" NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "price_minor" BIGINT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Listing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ListingSearchDocument" (
    "listing_id" TEXT NOT NULL,
    "body" TEXT NOT NULL,

    CONSTRAINT "ListingSearchDocument_pkey" PRIMARY KEY ("listing_id")
);

-- CreateTable
CREATE TABLE "VipSubscription" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VipSubscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdCampaign" (
    "id" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "ends_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReferralCode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReferralCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Achievement" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Achievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserAchievement" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "achievement_id" TEXT NOT NULL,
    "granted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idempotency_key" TEXT,

    CONSTRAINT "UserAchievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PromoCode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "max_uses" INTEGER NOT NULL DEFAULT 1,
    "used_count" INTEGER NOT NULL DEFAULT 0,
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PromoCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "channel" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "read_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SupportTicket" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "status" "SupportTicketStatus" NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SupportTicket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingSession" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "flow_version" INTEGER NOT NULL,
    "policy_version_id" TEXT,
    "current_step_key" TEXT,
    "ip_hash" TEXT,
    "last_activity_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OnboardingSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingStep" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "step_key" TEXT NOT NULL,
    "answer_given" TEXT,
    "is_correct" BOOLEAN,
    "is_mandatory" BOOLEAN NOT NULL DEFAULT true,
    "completed_at" TIMESTAMP(3),

    CONSTRAINT "OnboardingStep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingReward" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "idempotency_key" TEXT NOT NULL,
    "amount_minor" BIGINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OnboardingReward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingAuditLog" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "event" TEXT NOT NULL,
    "payload" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OnboardingAuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContextualOnboardingTip" (
    "id" TEXT NOT NULL,
    "action_key" TEXT NOT NULL,
    "tip_text" TEXT NOT NULL,

    CONSTRAINT "ContextualOnboardingTip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingContextualShown" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "action_key" TEXT NOT NULL,

    CONSTRAINT "OnboardingContextualShown_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserTestAttempt" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "test_key" TEXT NOT NULL,
    "score" INTEGER,
    "passed" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserTestAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LegalAcceptance" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "document_key" TEXT NOT NULL,
    "policy_version" TEXT NOT NULL,
    "accepted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LegalAcceptance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlatformUiSettings" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "onboarding_flow_version" INTEGER NOT NULL DEFAULT 1,
    "maintenance_mode" BOOLEAN NOT NULL DEFAULT false,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlatformUiSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProcessedTelegramUpdate" (
    "id" TEXT NOT NULL,
    "bot_kind" TEXT NOT NULL,
    "update_id" BIGINT NOT NULL,
    "received_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProcessedTelegramUpdate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CallbackNonce" (
    "id" TEXT NOT NULL,
    "nonce" TEXT NOT NULL,
    "user_id" TEXT,
    "payload" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CallbackNonce_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FraudReport" (
    "id" TEXT NOT NULL,
    "deal_id" TEXT NOT NULL,
    "reporter_id" TEXT NOT NULL,
    "accused_id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FraudReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ArchiveRecord" (
    "id" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "storage_ref" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ArchiveRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminAuditLog" (
    "id" TEXT NOT NULL,
    "admin_id" TEXT,
    "action" TEXT NOT NULL,
    "target_type" TEXT,
    "target_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminAuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Deployment" (
    "id" TEXT NOT NULL,
    "environment" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "commit_hash" TEXT,
    "migration_version" TEXT,
    "deployed_by" TEXT,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "rollback_version" TEXT,

    CONSTRAINT "Deployment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FeatureFlag" (
    "id" TEXT NOT NULL,
    "flag_key" TEXT NOT NULL,
    "environment" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "rollout_percent" INTEGER NOT NULL DEFAULT 0,
    "conditions_json" JSONB,
    "enabled_by_admin_id" TEXT,
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FeatureFlag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Incident" (
    "id" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),
    "owner_admin_id" TEXT,
    "summary" TEXT,
    "postmortem_url" TEXT,
    "affected_services_json" JSONB,

    CONSTRAINT "Incident_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncidentEvent" (
    "id" TEXT NOT NULL,
    "incident_id" TEXT NOT NULL,
    "actor_id" TEXT,
    "event_type" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IncidentEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemHealthCheck" (
    "id" TEXT NOT NULL,
    "service_name" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "latency_ms" INTEGER,
    "checked_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata_json" JSONB,

    CONSTRAINT "SystemHealthCheck_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BackupJob" (
    "id" TEXT NOT NULL,
    "backup_type" TEXT NOT NULL,
    "environment" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(3),
    "storage_ref" TEXT,
    "checksum" TEXT,
    "checksum_verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_at" TIMESTAMP(3),

    CONSTRAINT "BackupJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InfrastructureAuditLog" (
    "id" TEXT NOT NULL,
    "actor_id" TEXT,
    "action" TEXT NOT NULL,
    "service" TEXT NOT NULL,
    "old_value" TEXT,
    "new_value" TEXT,
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InfrastructureAuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_telegram_user_id_key" ON "User"("telegram_user_id");

-- CreateIndex
CREATE INDEX "UserRole_user_id_idx" ON "UserRole"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserRole_user_id_role_key" ON "UserRole"("user_id", "role");

-- CreateIndex
CREATE UNIQUE INDEX "AdminUser_user_id_key" ON "AdminUser"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "Profile_user_id_key" ON "Profile"("user_id");

-- CreateIndex
CREATE INDEX "RobloxVerification_user_id_idx" ON "RobloxVerification"("user_id");

-- CreateIndex
CREATE INDEX "DealEvent_deal_id_created_at_idx" ON "DealEvent"("deal_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "DealChat_deal_id_key" ON "DealChat"("deal_id");

-- CreateIndex
CREATE UNIQUE INDEX "DealInvite_nonce_key" ON "DealInvite"("nonce");

-- CreateIndex
CREATE INDEX "DealInvite_deal_chat_id_idx" ON "DealInvite"("deal_chat_id");

-- CreateIndex
CREATE UNIQUE INDEX "DealApplication_idempotency_key_key" ON "DealApplication"("idempotency_key");

-- CreateIndex
CREATE INDEX "DealApplication_seller_id_status_idx" ON "DealApplication"("seller_id", "status");

-- CreateIndex
CREATE INDEX "DealApplication_client_id_status_idx" ON "DealApplication"("client_id", "status");

-- CreateIndex
CREATE INDEX "Review_deal_id_idx" ON "Review"("deal_id");

-- CreateIndex
CREATE INDEX "Review_target_id_idx" ON "Review"("target_id");

-- CreateIndex
CREATE UNIQUE INDEX "Wallet_user_id_currency_key" ON "Wallet"("user_id", "currency");

-- CreateIndex
CREATE UNIQUE INDEX "LedgerAccount_wallet_id_kind_key" ON "LedgerAccount"("wallet_id", "kind");

-- CreateIndex
CREATE UNIQUE INDEX "LedgerJournal_idempotency_key_key" ON "LedgerJournal"("idempotency_key");

-- CreateIndex
CREATE INDEX "LedgerLine_account_id_idx" ON "LedgerLine"("account_id");

-- CreateIndex
CREATE INDEX "LedgerLine_journal_id_idx" ON "LedgerLine"("journal_id");

-- CreateIndex
CREATE UNIQUE INDEX "Withdrawal_idempotency_key_key" ON "Withdrawal"("idempotency_key");

-- CreateIndex
CREATE INDEX "Withdrawal_user_id_status_idx" ON "Withdrawal"("user_id", "status");

-- CreateIndex
CREATE INDEX "Listing_seller_id_game_idx" ON "Listing"("seller_id", "game");

-- CreateIndex
CREATE INDEX "VipSubscription_user_id_idx" ON "VipSubscription"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "ReferralCode_code_key" ON "ReferralCode"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Achievement_key_key" ON "Achievement"("key");

-- CreateIndex
CREATE UNIQUE INDEX "UserAchievement_idempotency_key_key" ON "UserAchievement"("idempotency_key");

-- CreateIndex
CREATE UNIQUE INDEX "UserAchievement_user_id_achievement_id_key" ON "UserAchievement"("user_id", "achievement_id");

-- CreateIndex
CREATE UNIQUE INDEX "PromoCode_code_key" ON "PromoCode"("code");

-- CreateIndex
CREATE INDEX "Notification_user_id_created_at_idx" ON "Notification"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "OnboardingSession_user_id_completed_at_idx" ON "OnboardingSession"("user_id", "completed_at");

-- CreateIndex
CREATE INDEX "OnboardingStep_session_id_idx" ON "OnboardingStep"("session_id");

-- CreateIndex
CREATE UNIQUE INDEX "OnboardingReward_idempotency_key_key" ON "OnboardingReward"("idempotency_key");

-- CreateIndex
CREATE INDEX "OnboardingAuditLog_user_id_created_at_idx" ON "OnboardingAuditLog"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "ContextualOnboardingTip_action_key_key" ON "ContextualOnboardingTip"("action_key");

-- CreateIndex
CREATE UNIQUE INDEX "OnboardingContextualShown_user_id_action_key_key" ON "OnboardingContextualShown"("user_id", "action_key");

-- CreateIndex
CREATE INDEX "UserTestAttempt_user_id_idx" ON "UserTestAttempt"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "LegalAcceptance_user_id_document_key_policy_version_key" ON "LegalAcceptance"("user_id", "document_key", "policy_version");

-- CreateIndex
CREATE UNIQUE INDEX "ProcessedTelegramUpdate_bot_kind_update_id_key" ON "ProcessedTelegramUpdate"("bot_kind", "update_id");

-- CreateIndex
CREATE UNIQUE INDEX "CallbackNonce_nonce_key" ON "CallbackNonce"("nonce");

-- CreateIndex
CREATE INDEX "FraudReport_deal_id_idx" ON "FraudReport"("deal_id");

-- CreateIndex
CREATE INDEX "AdminAuditLog_created_at_idx" ON "AdminAuditLog"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "FeatureFlag_flag_key_environment_key" ON "FeatureFlag"("flag_key", "environment");

-- CreateIndex
CREATE INDEX "IncidentEvent_incident_id_idx" ON "IncidentEvent"("incident_id");

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminUser" ADD CONSTRAINT "AdminUser_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RobloxVerification" ADD CONSTRAINT "RobloxVerification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Deal" ADD CONSTRAINT "Deal_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Deal" ADD CONSTRAINT "Deal_seller_id_fkey" FOREIGN KEY ("seller_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealEvent" ADD CONSTRAINT "DealEvent_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "Deal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealChat" ADD CONSTRAINT "DealChat_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "Deal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealInvite" ADD CONSTRAINT "DealInvite_deal_chat_id_fkey" FOREIGN KEY ("deal_chat_id") REFERENCES "DealChat"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealApplication" ADD CONSTRAINT "DealApplication_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealApplication" ADD CONSTRAINT "DealApplication_seller_id_fkey" FOREIGN KEY ("seller_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DealApplication" ADD CONSTRAINT "DealApplication_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "Deal"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Wallet" ADD CONSTRAINT "Wallet_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerAccount" ADD CONSTRAINT "LedgerAccount_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "Wallet"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerLine" ADD CONSTRAINT "LedgerLine_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "LedgerJournal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerLine" ADD CONSTRAINT "LedgerLine_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "LedgerAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Withdrawal" ADD CONSTRAINT "Withdrawal_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_seller_id_fkey" FOREIGN KEY ("seller_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnboardingSession" ADD CONSTRAINT "OnboardingSession_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnboardingStep" ADD CONSTRAINT "OnboardingStep_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "OnboardingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

