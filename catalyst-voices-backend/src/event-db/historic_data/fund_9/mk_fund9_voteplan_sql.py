import argparse
import sqlite3


event_id = 9


def voteplans_sql(sqlite3_con: sqlite3.Connection) -> str:
    lines = []
    cur = sqlite3_con.cursor()

    rows = cur.execute(
        "SELECT chain_voteplan_id, chain_voteplan_payload, chain_vote_encryption_key FROM voteplans"
    ).fetchall()
    for row in rows:
        id = row[0]
        category = row[1]
        encryption_key = row[2]

        lines.append(
            f"""
DELETE FROM voteplan WHERE id = '{id}';
INSERT INTO voteplan (objective_id, id, category, encryption_key)
SELECT
    MIN(row_id),
    '{id}',
    '{category}',
    '{encryption_key}'
FROM objective;
""".strip()
        )

    cur.close()

    return "\n".join(lines)


def proposal_voteplans_sql(sqlite3_con: sqlite3.Connection) -> str:
    lines = []
    cur = sqlite3_con.cursor()

    for row in cur.execute("SELECT proposal_id FROM proposals").fetchall():
        proposal_id = row[0]

        row = cur.execute(
            "SELECT chain_voteplan_id, chain_proposal_index FROM proposals WHERE proposal_id = $1",
            (str(proposal_id),),
        ).fetchone()

        chain_voteplan_id = row[0]
        chain_proposal_index = row[1]

        lines.append(
            f"""
INSERT INTO proposal_voteplan (proposal_id, voteplan_id, bb_proposal_index)
SELECT
    (SELECT row_id FROM proposal WHERE id = {proposal_id}),
    row_id,
    {chain_proposal_index}
FROM voteplan
WHERE id = '{chain_voteplan_id}';
""".strip()
        )

    cur.close()
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description=f"Extract voteplans from F{event_id} and generate SQL statements for inserting them in event-db."
    )
    parser.add_argument(
        "filename",
        help=f"Sqlite3 Fund{event_id} file to read.",
    )

    args = parser.parse_args()

    con = sqlite3.connect(args.filename)
    print(voteplans_sql(con) + "\n\n" + proposal_voteplans_sql(con))
    con.close()


if __name__ == "__main__":
    main()
