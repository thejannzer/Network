#passwort generator
import secrets
import string

def generate_password(length=15):
    alphabet=(
        string.ascii_letters +
        string.digits
    )

    password = ''.join(secrets.choice(alphabet) for _ in range(length))
    return password

print(f"Passwort: {generate_password()}")