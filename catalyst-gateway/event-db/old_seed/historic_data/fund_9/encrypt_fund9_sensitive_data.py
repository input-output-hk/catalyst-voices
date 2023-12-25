import argparse
import base64
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.asymmetric.rsa import RSAPublicKey
from cryptography.hazmat.primitives import hashes, serialization
import os.path
import shutil
import sqlite3

event_id = 9


class Encryptor:
    @staticmethod
    def from_public_key_pem_file(path: str):
        with open(path, "rb") as f:
            rsa_pk = serialization.load_pem_public_key(data=f.read())

            if not isinstance(rsa_pk, RSAPublicKey):
                print("Invalid key type: must be a RSA key")
                exit(1)

            if rsa_pk.key_size != 4096:
                print("Invalid key size: must be 4096 bits")
                exit(1)

            return Encryptor(rsa_pk)

    def __init__(self, pk: RSAPublicKey):
        self.rsa_pk = pk
        self.encoded_rsa_pk_der = base64.b64encode(
            self.rsa_pk.public_bytes(
                serialization.Encoding.DER,
                serialization.PublicFormat.SubjectPublicKeyInfo,
            )
        ).decode()

    def encrypt(self, plaintext: bytes) -> str:
        ciphertext = self.rsa_pk.encrypt(
            plaintext,
            padding=padding.OAEP(
                padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None,
            ),
        )

        encoded_ciphertext = base64.b64encode(ciphertext).decode()

        return f"RSA:{self.encoded_rsa_pk_der}:{encoded_ciphertext}"


def encrypt_proposals_sensitive_data(
    encryptor: Encryptor, src_con: sqlite3.Connection, dst_con: sqlite3.Connection
):
    src_cur = src_con.cursor()
    dst_cur = dst_con.cursor()

    rows = src_cur.execute("SELECT id, proposal_public_key FROM proposals").fetchall()

    data = []
    for row in rows:
        id = row[0]
        c = row[1]

        data.append((id, encryptor.encrypt(bytes(c, "utf-8"))))

    for id, d in data:
        dst_cur.execute(
            f"UPDATE proposals SET proposal_public_key = ? WHERE id = ?", (d, id)
        )

    src_cur.close()
    dst_cur.close()


def main():
    parser = argparse.ArgumentParser(
        description=f"Encrypt fund {event_id} sensitive data."
    )
    parser.add_argument(
        "--db-path",
        help=f"Sqlite3 Fund{event_id} file to read.",
    )
    parser.add_argument(
        "--public-key-path",
        help="PEM file path for the RSA (4096 bits) public key to use when encrypting data.",
    )

    args = parser.parse_args()

    (db_path_base, _) = os.path.split(args.db_path)
    out_filepath = os.path.join(
        db_path_base, f"fund{event_id}_database_encrypted.sqlite3"
    )

    shutil.copyfile(args.db_path, out_filepath)

    src_con = sqlite3.connect(args.db_path)
    dst_con = sqlite3.connect(out_filepath)

    encryptor = Encryptor.from_public_key_pem_file(args.public_key_path)

    encrypt_proposals_sensitive_data(encryptor, src_con, dst_con)

    src_con.close()
    dst_con.commit()
    dst_con.close()


if __name__ == "__main__":
    main()
