import json
from typing import Any
from typing import Dict

import boto3


def get_secrets(secret_name: str) -> Dict[str, Any]:
    client = _init_conn()
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)

    return json.loads(get_secret_value_response["SecretString"])


def _init_conn():
    region_name = "ap-southeast-1"

    session = boto3.session.Session()
    return session.client(service_name="secretsmanager", region_name=region_name)
