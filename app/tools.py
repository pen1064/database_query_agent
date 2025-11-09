import os, psycopg2, math

async def calculator(expression: str) -> str:
    try:
        return str(eval(expression, {"__builtins__": None, "math": math}))
    except Exception as e:
        return f"Error: {e}"

async def db_query(sql: str) -> str:
    db_url = os.getenv("DATABASE_URL")
    try:
        conn = psycopg2.connect(db_url)
        cur = conn.cursor()
        cur.execute(sql)
        if cur.description:
            cols = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            conn.close()
            if not rows:
                return "No results."
            header = " | ".join(cols)
            data = "\n".join(" | ".join(str(x) for x in r) for r in rows)
            return f"{header}\n{data}"
        else:
            conn.commit()
            conn.close()
            return "Query executed."
    except Exception as e:
        return f"SQL Error: {e}"


async def check_schema() -> str:
    """
    Return a list of all tables and columns in the database.
    Useful for schema discovery.
    """
    db_url = os.getenv("DATABASE_URL")
    try:
        conn = psycopg2.connect(db_url)
        cur = conn.cursor()

        query = """
        SELECT table_name, column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position;
        """
        cur.execute(query)
        rows = cur.fetchall()
        conn.close()

        # Pretty print schema info
        schema_info = {}
        for table, col, dtype in rows:
            schema_info.setdefault(table, []).append(f"{col} ({dtype})")

        formatted = "\n".join(
            f"{table}: {', '.join(cols)}" for table, cols in schema_info.items()
        )
        return formatted
    except Exception as e:
        return f"Schema Error: {e}"


async def check_metadata(table_name: str = None) -> str:
    """
    Return metadata about tables (purpose, domain, relationships).
    """
    db_url = os.getenv("DATABASE_URL")
    try:
        conn = psycopg2.connect(db_url)
        cur = conn.cursor()

        if table_name:
            cur.execute(
                "SELECT table_name, domain, description, related_tables FROM table_metadata WHERE table_name ILIKE %s;",
                (table_name,)
            )
        else:
            cur.execute(
                "SELECT table_name, domain, description, related_tables FROM table_metadata ORDER BY domain, table_name;"
            )

        rows = cur.fetchall()
        conn.close()

        if not rows:
            return "No metadata found for that table."

        result = []
        for tname, domain, desc, rel in rows:
            result.append(f"{tname} ({domain}) - {desc}. Related: {rel}")
        return "\n".join(result)
    except Exception as e:
        return f"Metadata Error: {e}"
