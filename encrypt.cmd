awscli kms encrypt --key-id <your kms uid> --plaintext fileb://secrets/keys.json --output text --query CiphertextBlob > tmp.txt

certutil -decode tmp.txt app/encrypted-secrets

del tmp.txt