import cognitojwt

region = "ca-central-1"
userpool_id = "ca-central-1_MHa7IjSrw"
app_client_id = "3b9okcenun1vherojjv4hc6rb3"
keys_url = "https://cognito-idp.{}.amazonaws.com/{}/.well-known/jwks.json".format(
    region, userpool_id
)


def verify_token(token):
    verified_claims: dict = cognitojwt.decode(
        token,
        region,
        userpool_id,
        app_client_id=app_client_id,  # Optional
        testmode=True,  # Disable token expiration check for testing purposes
    )

    return verified_claims
