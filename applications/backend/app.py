from flask import Flask, jsonify
import boto3
import psycopg2
import json

app = Flask(__name__)

def get_ssm_parameter(parameter_name):
    ssm_client = boto3.client('ssm')
    response = ssm_client.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return response['Parameter']['Value']

def get_db_connection():
    # Get database credentials from SSM
    db_host = get_ssm_parameter('/rds/db/ll-db-init/dbname')
    db_name = get_ssm_parameter('/rds/db/ll-db-init/identifier')
    db_user = get_ssm_parameter('/rds/db/ll-db-init/superuser/username')
    db_password = get_ssm_parameter('/rds/db/ll-db-init/superuser/password')

    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password
    )
    return conn

@app.route('/info')
def get_info():
    try:
        # Get PostgreSQL version
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT version();')
        db_version = cur.fetchone()[0]
        cur.close()
        conn.close()

        # Get SSM parameters
        ssm_params = {
            'dbname': get_ssm_parameter('/rds/db/ll-db-init/dbname'),
            'identifier': get_ssm_parameter('/rds/db/ll-db-init/identifier'),
            'superuser_password': get_ssm_parameter('/rds/db/ll-db-init/superuser/password'),
            'superuser_username': get_ssm_parameter('/rds/db/ll-db-init/superuser/username')
        }

        response_data = {
            'data': {
                'DB Info': db_version,
                'DB Connection Info': [
                    {'Name': '/rds/db/ll-db-init/dbname', 'Value': ssm_params['dbname']},
                    {'Name': '/rds/db/ll-db-init/identifier', 'Value': ssm_params['identifier']},
                    {'Name': '/rds/db/ll-db-init/superuser/password', 'Value': ssm_params['superuser_password']},
                    {'Name': '/rds/db/ll-db-init/superuser/username', 'Value': ssm_params['superuser_username']}
                ]
            }
        }

        return jsonify(response_data)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)