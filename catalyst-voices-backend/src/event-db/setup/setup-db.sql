-- Initialize the Project Catalyst Event Database.

-- This script requires a number of variables to be set.
-- They will default if not set externally.
-- These variables can be set on the "psql" command line.
-- Passwords may optionally be set by ENV Vars.
-- This script requires "psql" is run inside a POSIX compliant shell.

-- VARIABLES:

-- The name of the Database to connect to.
\if :{?dbName} \else
  \set dbName CatalystEventDev
\endif

-- The description of the database.
\if :{?dbDescription} \else
  \set dbDescription 'Catalyst Event DB'
\endif


-- The db user with full permissions on the DB.
\if :{?dbUser} \else
  \set dbUser 'catalyst-event-dev'
\endif

-- The db users password.
\if :{?dbUserPw} \else
  \set dbUserPw `echo ${DB_USER_PW:-CHANGE_ME}`
\endif

-- DISPLAY ALL VARIABLES
\echo VARIABLES:
\echo -> dbName ................. = :dbName
\echo -> dbDescription .......... = :dbDescription
\echo -> dbUser ................. = :dbUser
\echo -> dbUserPw / $DB_USER_PW . = :dbUserPw


-- Cleanup if we already ran this before.
DROP DATABASE IF EXISTS :"dbName";

DROP USER IF EXISTS :"dbUser";

-- Create the test user we will use with the local Catalyst-Event dev database.
CREATE USER :"dbUser" WITH PASSWORD :'dbUserPw';

-- Privileges for this user/role.
ALTER DEFAULT privileges REVOKE EXECUTE ON functions FROM public;

ALTER DEFAULT privileges IN SCHEMA public REVOKE EXECUTE ON functions FROM :"dbUser";

-- Create the database.
CREATE DATABASE :"dbName" WITH OWNER :"dbUser";

COMMENT ON DATABASE :"dbName" IS :'dbDescription';

