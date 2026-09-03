import os
from unittest import TestCase
from unittest.mock import patch

os.environ.setdefault("COGNITO_REGION", "test-region")
os.environ.setdefault("COGNITO_USERPOOL_ID", "test-user-pool")
os.environ.setdefault("COGNITO_APP_CLIENT_ID", "test-client")

from users import cognito


class VerifyTokenTests(TestCase):
    @patch("users.cognito.decode")
    def test_verify_token_returns_verified_claims(self, mock_decode):
        claims = {"email": "test@example.com"}
        mock_decode.return_value = claims

        result = cognito.verify_token("test-token")

        self.assertEqual(result, claims)
        mock_decode.assert_called_once_with(
            "test-token",
            cognito.region,
            cognito.userpool_id,
            app_client_id=cognito.app_client_id,
            testmode=False,
        )