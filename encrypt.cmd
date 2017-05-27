@echo off
rem provide your kms uuid as a parameter
aws kms encrypt --key-id %1 --plaintext fileb://secrets/keys.json --output text --query CiphertextBlob > tmp.txt
certutil -decode tmp.txt app/encrypted-secrets
del tmp.txt