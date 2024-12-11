import psycopg
import pytest
import pybars
import jinja2


jinja_env = jinja2.Environment(
    loader=jinja2.FileSystemLoader("./queries/"),
)


class SignedData:
    def __init__(
        self,
        id: str,
        ver: str,
        doc_type: str,
        author: str,
        metadata: str,
        payload: str,
        raw: bytes,
    ):
        self.id = id
        self.ver = ver
        self.doc_type = doc_type
        self.author = author
        self.metadata = metadata
        self.payload = payload
        self.raw = raw

    def to_tuple(self):
        return (
            self.id,
            self.ver,
            self.doc_type,
            self.author,
            self.metadata,
            self.payload,
            self.raw,
        )


EVENT_DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"


@pytest.mark.ci
def test_signed_docs_queries():
    with psycopg.connect(EVENT_DB_URL) as conn:
        docs = [
            SignedData(
                id="3764e30b-9bb5-4a34-906e-f4de1845e8bf",
                ver="299255cb-9f53-46ec-8e24-4360b9d374bd",
                doc_type="c17f59b2-1304-4a75-923e-00795add70af",
                author="Alex",
                metadata="{}",
                payload="{}",
                raw=b"bytes1",
            ),
            SignedData(
                id="4ee05138-e85b-48b4-91c2-2a45a74a0a82",
                ver="3cd78d6c-9388-47ab-9a65-f3a84c76190f",
                doc_type="fec1b996-ad89-4fab-a787-6568f42b00b1",
                author="Steven",
                metadata="{}",
                payload="{}",
                raw=b"bytes2",
            ),
        ]

        insert_signed_documents_query(conn, docs)
        # try insert the same values
        insert_signed_documents_query(conn, docs)
        select_signed_documents_query(conn, docs)
        select_signed_documents_2_query(conn, docs)

        # try insert the same id and ver, but with the different other data
        docs[0].author = "Sasha"
        docs[1].author = "Sasha"
        should_panic(
            lambda: insert_signed_documents_query(conn, docs),
            "insert_signed_documents_query should fail",
        )
        should_panic(
            lambda: select_signed_documents_query(conn, docs),
            "select_signed_documents_query should fail",
        )
        should_panic(
            lambda: select_signed_documents_2_query(conn, docs),
            "select_signed_documents_2_query should fail",
        )


def insert_signed_documents_query(conn, docs: [SignedData]):
    insert_signed_documents_sql = open(
        "./queries/insert_signed_documents.sql", "r"
    ).read()
    insert_signed_documents_sql = (
        insert_signed_documents_sql.replace("$1", "%s")
        .replace("$2", "%s")
        .replace("$3", "%s")
        .replace("$4", "%s")
        .replace("$5", "%s")
        .replace("$6", "%s")
        .replace("$7", "%s")
    )
    for doc in docs:
        conn.execute(insert_signed_documents_sql, doc.to_tuple())


def select_signed_documents_query(conn, docs: [SignedData]):
    select_signed_documents_sql = open(
        "./queries/select_signed_documents.sql", "r"
    ).read()
    select_signed_documents_sql = select_signed_documents_sql.replace(
        "$1", "%s"
    ).replace("$2", "%s")
    for doc in docs:
        cur = conn.execute(
            select_signed_documents_sql,
            (doc.id, doc.ver),
        )
        (id, ver, doc_type, author, metadata, payload, raw) = cur.fetchone()
        assert str(id) == doc.id
        assert str(ver) == doc.ver
        assert str(doc_type) == doc.doc_type
        assert author == doc.author
        assert str(metadata) == doc.metadata
        assert str(payload) == doc.payload
        assert raw == doc.raw


def select_signed_documents_2_query(conn, docs: [SignedData]):
    template = jinja_env.get_template("select_signed_documents_2.sql.jinja")
    for doc in docs:
        sql_stmt = template.render(
            {
                "conditions": f"signed_docs.id = '{doc.id}' AND signed_docs.ver = '{doc.ver}'",
                "limit": 1,
                "offset": 0,
            }
        )
        cur = conn.execute(sql_stmt)
        (id, ver, doc_type, author, metadata) = cur.fetchone()
        assert str(id) == doc.id
        assert str(ver) == doc.ver
        assert str(doc_type) == doc.doc_type
        assert author == doc.author
        assert str(metadata) == doc.metadata


def should_panic(func, msg: str):
    try:
        func()
        assert False, msg
    except:
        pass
