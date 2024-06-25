CREATE TABLE tb_endpoints (
	id serial primary key,
	identifier TEXT,
	password TEXT
);

CREATE TABLE tb_log (
	id serial primary key,
	endpoint_identifier TEXT,
	log_identifier TEXT,
	timestamp BIGINT,
	message JSON
);

INSERT INTO tb_endpoints (
	identifier,
	password
) VALUES (
	'foobar',
	'foobar'
);
