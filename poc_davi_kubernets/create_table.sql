create table IF NOT EXISTS finance_info (
	id INT not null,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	gender VARCHAR(50),
	credit_card_holder VARCHAR(50),
	cpf VARCHAR(20),
	department_retail VARCHAR(50),
	amount VARCHAR(50),
	credit_card_number VARCHAR(50),
	transaction_date BIGINT
);