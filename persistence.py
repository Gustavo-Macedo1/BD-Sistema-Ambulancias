import pandas as pd
import mysql.connector
from mysql.connector import errorcode


# Conectar ao banco de dados local
def connect_bd(user='root', password='', host='127.0.0.1', database='gestaoambulancias', port=3306):
  try:
    cnx = mysql.connector.connect(user=user, password=password,
                              host=host,
                              database=database, port=port)
    return cnx
    
  except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
      print("Something is wrong with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
      print("Database does not exist")
    else:
      print(err)
    cnx.close()

def get_column_types(cnx, table_name, schema="gestaoambulancias"):
    cursor = cnx.cursor()
    query = """
        SELECT COLUMN_NAME, DATA_TYPE 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
    """
    cursor.execute(query, (schema, table_name))
    types = {col: dtype for col, dtype in cursor.fetchall()}
    cursor.close()
    return types

# Retorna tabela completa em DataFrame
def select_all_df(cnx, table):
  if cnx.is_connected():
    cursor = cnx.cursor()
    query = f"SELECT * FROM {table};"
    cursor.execute(query)
    results = cursor.fetchall()
    df = pd.DataFrame(results, columns=[i[0] for i in cursor.description])
    df = df.reset_index(drop=True)
    cursor.close()
    return df

# CRUD
def create(cnx, query, values):
  if cnx.is_connected():
    cursor = cnx.cursor()
    cursor.execute(query, values)
    cnx.commit()
    cursor.close()

def read(cnx, query):
  if cnx.is_connected():
    cursor = cnx.cursor()
    cursor.execute(query)
    cnx.commit()
    cursor.close()

def update(cnx, query, values):
  if cnx.is_connected():
    cursor = cnx.cursor()
    cursor.execute(query, values)
    cnx.commit()
    cursor.close()

def delete(cnx, query):
  if cnx.is_connected():
    cursor = cnx.cursor()
    cursor.execute(query)
    cnx.commit()
    cursor.close()