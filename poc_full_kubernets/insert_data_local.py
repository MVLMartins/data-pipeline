import numpy as np
import psycopg2
import time


if __name__ == "__main__":
    con = psycopg2.connect(
        user="admin", 
        password="admin", 
        database="db_kafka_test",
    )
    cur = con.cursor()
    create = open("create_table.sql").read()
    print(create[0])
    cur.execute(create)
    con.commit() 
    data = open("create_rows.sql").readlines()

    for query in data:
        print("Executando query:\n")
        print(query,"\n")
        cur.execute(query)
        con.commit() 
        time.sleep(2.5)