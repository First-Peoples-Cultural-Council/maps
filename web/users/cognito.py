import os
import cognitojwt
from jose.exceptions import ExpiredSignatureError, JWTError

# Get environment variables
region = os.environ["COGNITO_REGION"]
userpool_id = os.environ["COGNITO_USERPOOL_ID"]
app_client_id = os.environ["COGNITO_APP_CLIENT_ID"]
keys_url = "https://cognito-idp.{}.amazonaws.com/{}/.well-known/jwks.json".format(
    region, userpool_id
)


def verify_token(token):
    try:
        # Attempt to decode the token using cognitojwt
        verified_claims: dict = cognitojwt.decode(
            token,
            region,
            userpool_id,
            app_client_id=app_client_id,
            testmode=False,  # Ensures expiration is checked
        )

        # Return the claims if decoding is successful
        return verified_claims

    except ExpiredSignatureError:
        print("Token has expired.")
        return None  # Handle expired token scenario

    except JWTError as e:
        print(f"JWT error: {e}")
        return None  # Handle other JWT errors (invalid token, incorrect signature, etc.)

    except Exception as e:
        print(f"Unexpected error: {e}")
        return None  # Handle any unexpected errors


