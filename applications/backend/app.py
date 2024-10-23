import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)
   
def get_db_connection():
    conn = psycopg2.connect( 
        host=os.environ['DB_HOST'],
        database=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD']
    )
    return conn

@app.route('/info')
def get_connection_info():   
    # Get the connection information
    conn = get_db_connection()
    connection_info = conn.get_dsn_parameters()
    print(connection_info)
    # Convert the connection info to a JSON response
    return jsonify(connection_info)
   
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)