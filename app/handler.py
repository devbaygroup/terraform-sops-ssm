import json
from typing import Any
from typing import Dict

from utils.secretsmanager import get_secrets


secrets = get_secrets(
    "arn:aws:secretsmanager:ap-southeast-1:$AWS_ACCOUNT_ID:secret:db-foo-4iBhZR"
)


def handler(raw_event: Dict[str, Any], context):
    return {
        "statusCode": 200,
        "body": json.dumps(secrets),  # for demonstration purpose only
    }


if __name__ == "__main__":
    d = {"age": 12}
    r = handler(d, None)

    from pprint import pprint

    pprint(r)
