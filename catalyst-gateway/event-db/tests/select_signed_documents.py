import psycopg
import time


time.sleep(5)

# Connect to your postgres DB
with psycopg.connect(
    "postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
) as conn:
    print("Connected to the event-db")
