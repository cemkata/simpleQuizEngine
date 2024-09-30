BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "questions" (
	"ID"	INTEGER UNIQUE,
	"QUESTION_TEXT"	TEXT NOT NULL,
	"QUESTION_ANSWERS"	TEXT,
	"QUESTION_CORECT"	TEXT,
	"QUESTION_REF"	TEXT,
	"QUESTION_EXPLAIN"	TEXT,
	"QUESTION_ANSWERS_GRP"	TEXT,
	"QUESTION_ANSWERS_CNT"    TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
COMMIT;
