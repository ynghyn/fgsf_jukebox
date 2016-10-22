CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "last_visited" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "music_selections" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "song" varchar, "queued" boolean DEFAULT 't', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "commenter" varchar, "body" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO schema_migrations (version) VALUES ('20161019062410'), ('20161019062520'), ('20161019082527');


