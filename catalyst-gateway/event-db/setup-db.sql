-- Initialize the Project Catalyst Event Database.

-- cspell: words psql noqa datname

-- This script requires a number of variables to be set.
-- They will default if not set externally.
-- These variables can be set on the "psql" command line.
-- Passwords may optionally be set by ENV Vars.
-- This script requires "psql" is run inside a POSIX compliant shell.

-- VARIABLES:

-- DISPLAY ALL VARIABLES
\echo VARIABLES:
\echo -> dbName ................. = :dbName
\echo -> dbDescription .......... = :dbDescription
\echo -> dbUser ................. = :dbUser
\echo -> dbUserPw ............... = xxxx
\echo -> dbSuperUser ............ = :dbSuperUser

SET localApp.dbUser = :'dbUser';
SET localApp.dbName = :'dbName';
DO $$ 
DECLARE
    db_name TEXT := current_setting('localApp.dbName');
BEGIN
    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = db_name) THEN
        -- Prevent new connections
        EXECUTE format('ALTER DATABASE %I WITH ALLOW_CONNECTIONS false;', db_name);

        -- Terminate active connections
        EXECUTE format('SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = %L AND pid <> pg_backend_pid();', db_name);

    END IF;
END $$;

-- Cleanup if we already ran this before.
DROP DATABASE IF EXISTS :"dbName"; -- noqa: PRS
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gateway') THEN
        ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM gateway;
        DROP ROLE gateway;
    END IF;
END;
$$;

-- Create the test user we will use with the local dev database.
CREATE USER :"dbUser" WITH PASSWORD :'dbUserPw'; -- noqa: PRS

-- Privileges for this user/role.
ALTER DEFAULT PRIVILEGES GRANT EXECUTE ON FUNCTIONS TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO :"dbUser"; -- noqa: PRS

-- Create the database.
CREATE DATABASE :"dbName" WITH OWNER :"dbUser"; -- noqa: PRS

-- This is necessary for RDS to work.
GRANT :"dbUser" TO :"dbSuperUser";

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO :"dbUser"; -- noqa: PRS

COMMENT ON DATABASE :"dbName" IS :'dbDescription'; -- noqa: PRS
