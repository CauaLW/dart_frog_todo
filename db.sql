CREATE TABLE list_item (
	id varchar NOT NULL,
	description varchar NOT NULL,
	completed bool DEFAULT false NOT NULL,
	CONSTRAINT list_item_pk PRIMARY KEY (id),
	CONSTRAINT list_item_unique UNIQUE (id)
);