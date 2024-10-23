from flask import Flask, jsonify
import boto3
import psycopg2
import os

app = Flask(__name__)

def get_ssm_parameters():
    ssm = boto3.client('ssm')
    response = ssm.get_parameters_by_path(
        Path='/rds/db/ib-db-init',
        Recursive=True,
        WithDecryption=True
    )
    return response['Parameters']

@app.route('/info')
def get_db_info():
    try:
        # Connect to RDS
        conn = psycopg2.connect(
            dbname=os.environ.get('DB_NAME'),
            user=os.environ.get('DB_USER'),
            password=os.environ.get('DB_PASSWORD'),
            host=os.environ.get('DB_HOST')
        )
        
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        db_version = cursor.fetchone()[0]
        
        # Get SSM parameters
        ssm_params = get_ssm_parameters()
        
        # Format the response
        info = {
            "data": {
                "DB Info": db_version,
                "DB Connection Info": [
                    {"Name": param['Name'], "Value": param['Value']}
                    for param in ssm_params
                ]
            }
        }
        
        cursor.close()
        conn.close()
        
        return jsonify(info)
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)