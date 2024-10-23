import os
from flask import Flask, jsonify
import boto3
import psycopg2
import json

app = Flask(__name__)

# Create a session with credentials
session = boto3.Session(
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'],
    region_name=os.environ['AWS_REGION']
)

def list_all_ssm_parameters(path_prefix='/'):
    ssm_client = session.client('ssm')
    parameters = []
    
    try:
        paginator = ssm_client.get_paginator('get_parameters_by_path')
        response_iterator = paginator.paginate(
            Path=path_prefix,
            Recursive=True,
            WithDecryption=True
        )
        
        for response in response_iterator:
            for param in response['Parameters']:
                parameters.append({
                    'Name': param['Name'],
                    'Value': param['Value']
                })
                
        return parameters
    except Exception as e:
        print(f"Error listing parameters: {str(e)}")
        return []

# def get_db_connection():
#     # Get all parameters
#     params = list_all_ssm_parameters()
#     param_dict = {param['Name']: param['Value'] for param in params}
    
#     # Get database credentials from parameters
#     db_host = param_dict.get('/rds/db-host', '')
#     db_name = param_dict.get('/rds/db-name', '')
#     db_user = param_dict.get('/rds/db-user', '')
#     db_password = param_dict.get('/rds/db-password', '')

#     conn = psycopg2.connect(
#         host=db_host.split(':')[0],
#         database=db_name,
#         user=db_user,
#         password=db_password
#     )
#     return conn

@app.route('/info')
def get_info():
    try:
        all_params = list_all_ssm_parameters()
        # conn = get_db_connection()
        # cur = conn.cursor()
        # cur.execute('SELECT version();')
        # db_version = cur.fetchone()[0]
        # cur.close()
        # conn.close()

        # response_data = {
        #         'DB Info': db_version,
        #         'DB Connection Info': all_params
        #     }

        return jsonify(all_params)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)