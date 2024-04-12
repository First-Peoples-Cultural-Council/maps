import os
import cognitojwt

region = os.environ["COGNITO_REGION"]
userpool_id = os.environ["COGNITO_USERPOOL_ID"]
app_client_id = os.environ["COGNITO_APP_CLIENT_ID"]
keys_url = "https://cognito-idp.{}.amazonaws.com/{}/.well-known/jwks.json".format(
    region, userpool_id
)


def verify_token(token):
    verified_claims: dict = cognitojwt.decode(
        token,
        region,
        userpool_id,
        app_client_id=app_client_id,
        testmode=True,  # Disable token expiration check for testing purposes
    )

    return verified_claims
