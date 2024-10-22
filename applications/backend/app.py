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
def get_info():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT version();')
    db_version = cur.fetchone()[0]
    cur.close()
    conn.close()

    return jsonify({
        "DB Info": db_version,
        "DB Connection Info": [
            {"Name": "/rds/db/11-db-init/dbname", "Value": os.environ['DB_NAME']},
            {"Name": "/rds/db/11-db-init/endpoint", "Value": os.environ['DB_HOST']},
            {"Name": "/rds/db/11-db-init/identifier", "Value": "11-db-init"},
            {"Name": "/rds/db/11-db-init/superuser/password", "Value": "********"},
            {"Name": "/rds/db/11-db-init/superuser/username", "Value": os.environ['DB_USER']}
        ]
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)