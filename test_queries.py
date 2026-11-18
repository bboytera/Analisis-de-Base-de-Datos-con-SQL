"""SQL parser + SQLite query fixture; not a substitute for MySQL integration."""
import sqlite3
from pathlib import Path
import unittest
import sqlglot

ROOT = Path(__file__).resolve().parent

class QueryRegressionTests(unittest.TestCase):
    def test_schema_and_queries_parse_as_mysql(self):
        self.assertEqual(len(sqlglot.parse((ROOT/'CREATE_TABLES.sql').read_text(),read='mysql')),4)
        self.assertEqual(len(sqlglot.parse((ROOT/'SELECT.sql').read_text(),read='mysql')),10)

    def test_discount_and_historical_price_with_empty_invoice(self):
        queries = sqlglot.parse((ROOT/'SELECT.sql').read_text(),read='mysql')
        con = sqlite3.connect(':memory:')
        con.executescript('''CREATE TABLE clients(client_id INTEGER PRIMARY KEY,name TEXT,email TEXT);
        CREATE TABLE bills(bill_id INTEGER PRIMARY KEY,client_id INTEGER,status TEXT);
        CREATE TABLE bill_products(bill_product_id INTEGER PRIMARY KEY,bill_id INTEGER,product_id INTEGER,quantity INTEGER,price REAL,discount REAL);
        INSERT INTO clients VALUES(1,'Example','example@gmail.com');
        INSERT INTO bills VALUES(1,1,'open'),(2,1,'open');
        INSERT INTO bill_products VALUES(1,1,1,2,100,10),(2,1,1,1,50,100),(3,1,1,1,20,0);''')
        result = con.execute(queries[-1].sql(dialect='sqlite')).fetchall()
        self.assertEqual(result[0][-1],200.)
        self.assertEqual(result[0][-2],3)
        self.assertEqual(result[1][-1],0)
        con.close()

if __name__ == '__main__':
    unittest.main()
