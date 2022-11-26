import psycopg2
import psycopg2.extras
from fastapi import APIRouter

router = APIRouter()

def get_cities():
    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute("set search_path=schemaname;")
    cursor.execute("select * from cities ")
    #r = cursor.fetchall();
    result = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return result

@router.get("/cities/")
async def cities():
    return get_cities()