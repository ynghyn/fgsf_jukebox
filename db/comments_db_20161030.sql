PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "commenter" varchar, "body" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO "comments" VALUES(3,35,'CAT','ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ멋지심다','2016-10-30 17:41:13.823071','2016-10-30 17:41:13.823071');
INSERT INTO "comments" VALUES(4,40,'박샛별','아이폰5S, 아이폰5C도 사용 가능하게 해주세요!
그리고 라이브러리 리스트에 아티스트도 나오면 좋을것 같아요! 선택할때 아티스트가 누군지 궁금해요!:)','2016-10-30 18:25:43.874869','2016-10-30 18:25:43.874869');
INSERT INTO "comments" VALUES(5,39,'Good','신청곡 넣어주셔서 감사해요','2016-10-30 18:33:37.643812','2016-10-30 18:33:37.643812');
INSERT INTO "comments" VALUES(6,39,'호지니아니자나','의도치 않게 ....찬양의 매력에 빠졌어...','2016-10-30 18:38:56.669357','2016-10-30 18:38:56.669357');
INSERT INTO "comments" VALUES(7,39,'ㅎㅎ','Greater - mercyme 요 ♥','2016-10-30 18:39:58.106443','2016-10-30 18:39:58.106443');
INSERT INTO "comments" VALUES(8,39,'디사이플스','주가 지으신 이날에!!!!!!♥ ㅔ','2016-10-30 18:48:49.873885','2016-10-30 18:48:49.873885');
INSERT INTO "comments" VALUES(9,46,'B','김도현님 찬양도 넣어주세여','2016-10-30 18:49:25.980092','2016-10-30 18:49:25.980092');
INSERT INTO "comments" VALUES(10,47,' 천세혁','나는바보다','2016-10-30 18:51:57.143233','2016-10-30 18:51:57.143233');
INSERT INTO "comments" VALUES(11,47,'비와이','예수인교회 청년부 화이팅','2016-10-30 18:54:51.668725','2016-10-30 18:54:51.668725');
INSERT INTO "comments" VALUES(12,50,'호지니아니자나','의도치 않게.... 찬양에 빠졌다','2016-10-30 19:26:13.606794','2016-10-30 19:26:13.606794');
INSERT INTO "comments" VALUES(13,52,'나는 목사당','찬양가운데 임하시는 은혜....그리고 사랑 나눔','2016-10-30 20:03:15.782677','2016-10-30 20:03:15.782677');
INSERT INTO "comments" VALUES(14,52,'한정우','한정우 나보다 좀 못생겼당','2016-10-30 20:04:03.991653','2016-10-30 20:04:03.991653');
INSERT INTO "comments" VALUES(15,52,'할렐루야','왜 안되지? ㅠ
','2016-10-30 20:05:56.644916','2016-10-30 20:05:56.644916');
INSERT INTO "comments" VALUES(16,52,'','만들어 주셔서 감사합니다 ㅎㅎ','2016-10-30 20:11:09.155938','2016-10-30 20:11:09.155938');
INSERT INTO "comments" VALUES(17,52,'','삼결살 파티 다음주 6시','2016-10-30 20:13:20.955105','2016-10-30 20:13:20.955105');
INSERT INTO "comments" VALUES(18,54,'','좋타','2016-10-30 20:16:02.835532','2016-10-30 20:16:02.835532');
INSERT INTO "comments" VALUES(19,54,'','식당봉사 수고했어용','2016-10-30 20:17:55.087185','2016-10-30 20:17:55.087185');
COMMIT;
