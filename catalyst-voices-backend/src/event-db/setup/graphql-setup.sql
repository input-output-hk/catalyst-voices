-- GraphQL Support and Security Schema

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

-- The db user with full permissions on the DB.
-- This is the user the GraphQL server will use by default.
\if :{?dbUser} \else
  \set dbUser 'catalyst-event-dev'
\endif

-- The `cat_admin` role password.
\if :{?adminRolePw} \else
  \set adminRolePw `echo ${ADMIN_ROLE_PW:-CHANGE_ME}`
\endif

-- The `cat_anon` role password.
\if :{?anonRolePw} \else
  \set anonRolePw `echo ${ANON_ROLE_PW:-CHANGE_ME}`
\endif

-- The default Admin User login we populate into the database.

-- First Name
\if :{?adminUserFirstName} \else
  \set adminUserFirstName 'Admin'
\endif

-- Last Name
\if :{?adminUserLastName} \else
  \set adminUserLastName 'Default'
\endif

-- Description
\if :{?adminUserAbout} \else
  \set adminUserAbout 'Default Admin User'
\endif

-- Email Address (user login email).
\if :{?adminUserEmail} \else
  \set adminUserEmail 'admin.default@projectcatalyst.io'
\endif

-- Password.
\if :{?adminUserPw} \else
  \set adminUserPw `echo ${ADMIN_USER_PW:-CHANGE_ME}`
\endif

-- DISPLAY ALL VARIABLES
\echo VARIABLES:
\echo -> dbName ....................... = :dbName
\echo -> dbUser ....................... = :dbUser
\echo -> adminRolePw / $ADMIN_ROLE_PW . = ******
\echo -> anonRolePw / $ANON_ROLE_PW ... = ******
\echo -> adminUserFirstName ........... = :adminUserFirstName
\echo -> adminUserLastName ............ = :adminUserLastName
\echo -> adminUserAbout ............... = :adminUserAbout
\echo -> adminUserEmail ............... = :adminUserEmail
\echo -> adminUserPw / $ADMIN_USER_PW . = ******


-- SCHEMA STARTS HERE:

\connect :dbName;
-- This is NOT part of our schema proper.  It exists to support GraphQL Admin authorization ONLY.

-- Purge old data incase we are running this again.
DROP FUNCTION IF EXISTS private.current_acct;
DROP FUNCTION IF EXISTS private.current_role;
DROP FUNCTION IF EXISTS private.register_admin;
DROP FUNCTION IF EXISTS private.authenticate;

DROP TYPE IF EXISTS private.jwt_token;

DROP TABLE IF EXISTS private.admin_account;

DROP SCHEMA IF EXISTS private CASCADE;

REVOKE ALL PRIVILEGES ON SCHEMA public FROM cat_admin, cat_anon CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE :"dbName" FROM cat_admin, cat_anon CASCADE;
DROP ROLE IF EXISTS "cat_admin";
DROP ROLE IF EXISTS "cat_anon";

CREATE SCHEMA private;

ALTER DEFAULT privileges IN SCHEMA private REVOKE EXECUTE ON functions FROM public;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Defined Roles
CREATE ROLE "cat_admin" LOGIN PASSWORD :'adminRolePw';

COMMENT ON ROLE "cat_admin" IS 'Full Administrator Access to the Database.';

GRANT "cat_admin" TO :"dbUser";

-- Make this role available to our default DB user.
ALTER DEFAULT privileges IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM cat_admin;

ALTER DEFAULT privileges IN SCHEMA private REVOKE EXECUTE ON FUNCTIONS FROM cat_admin;

CREATE ROLE "cat_anon" LOGIN PASSWORD :'anonRolePw';

COMMENT ON ROLE "cat_anon" IS 'Unauthenticated Read Only Access to the Database.';

GRANT "cat_anon" TO :"dbUser";

-- Make this role available to our default DB user.
ALTER DEFAULT privileges IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM cat_anon;

ALTER DEFAULT privileges IN SCHEMA private REVOKE EXECUTE ON FUNCTIONS FROM cat_anon;

-- Allow all roles "usage" to private and public schemas
GRANT usage ON SCHEMA public TO :"dbUser", "cat_admin", "cat_anon";

GRANT usage ON SCHEMA private TO :"dbUser", "cat_admin", "cat_anon";

-- All roles can read the database
GRANT SELECT ON ALL tables IN SCHEMA public TO :"dbUser", "cat_anon", "cat_admin";

-- Only admin level roles can change data.
GRANT INSERT, UPDATE, DELETE ON ALL tables IN SCHEMA public TO :"dbUser", "cat_admin";

-- Table where we store our authenticated users information.
-- No user has direct access to this table.
CREATE TABLE private.admin_account(
  id serial PRIMARY KEY,
  first_name text NOT NULL CHECK (char_length(first_name) < 80),
  last_name text CHECK (char_length(last_name) < 80),
  role text,
  about text,
  email text NOT NULL UNIQUE CHECK (email ~* '^.+@.+\..+$'),
  password_hash text NOT NULL,
  created_at timestamp DEFAULT now()
);

-- Create default ADMIN user.
INSERT INTO private.admin_account(first_name, last_name, ROLE, about, email, password_hash)
  VALUES (
    :'adminUserFirstName',
    :'adminUserLastName',
    'cat_admin',
    :'adminUserAbout',
    :'adminUserEmail',
    crypt(:'adminUserPw', gen_salt('bf')));

-- Test that we added the default account OK.
SELECT
  *
FROM
  private.admin_account;

-- Function to get details about the current authenticated account.
-- Anyone can call this.
CREATE FUNCTION private.current_acct()
  RETURNS private.admin_account
  AS $$
DECLARE
  account private.admin_account;
BEGIN
  SELECT
    a.* INTO account
  FROM
    private.admin_account AS a
  WHERE
    id = nullif(current_setting('jwt.claims.admin_id', TRUE), '')::integer;
  IF NOT FOUND THEN
    account.id := - 1;
    account.first_name :=('');
    account.role :=('cat_anon');
    account.email :=('');
    account.created_at := now();
  END IF;
  account.password_hash :=('xxx');
  RETURN account;
END;
$$
LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION private.current_acct() IS 'Gets the account identified by our JWT.';

GRANT EXECUTE ON FUNCTION private.current_acct() TO :"dbUser", "cat_anon", "cat_admin";

-- Test if we can get the current account.
SELECT
  private.current_acct();

-- Get users current role.
CREATE FUNCTION private.current_role()
  RETURNS text
  AS $$
  SELECT
    current_setting('jwt.claims.role', TRUE);
$$
LANGUAGE sql STABLE;

-- Function to register an admin.
-- Should ONLY be executable by admin level accounts.
CREATE FUNCTION private.register_admin(first_name text, last_name text, email text, PASSWORD text, ROLE text DEFAULT 'cat_admin')
  RETURNS private.admin_account
  AS $$
DECLARE
  admin private.admin_account;
  ROLE TEXT;
BEGIN
  SELECT
    *
  FROM
    private.current_role() INTO ROLE;
  RAISE NOTICE 'role = %', ROLE;
  IF ROLE IS NULL OR ROLE != 'cat_admin' THEN
    RAISE EXCEPTION SQLSTATE '90001'
      USING MESSAGE = 'Not Authorized';
    END IF;
    INSERT INTO private.admin_account(first_name, last_name, ROLE, email, password_hash)
      VALUES (first_name, last_name, ROLE, email, crypt(PASSWORD, gen_salt('bf')))
    RETURNING
      * INTO admin;
    admin.password_hash :=('xxx');
    RETURN admin;
END;
$$
LANGUAGE plpgsql STRICT SECURITY DEFINER;

COMMENT ON FUNCTION private.register_admin(text, text, text, text, text) IS 'Registers a single admin user and creates an account.';

GRANT EXECUTE ON FUNCTION private.register_admin(text, text, text, text, text) TO :"dbUser", "cat_admin";


-- Define special type for JWT Authentication logic in server
CREATE TYPE private.jwt_token AS (
  ROLE text,
  admin_id integer,
  exp bigint
);

-- Function to authenticate, GraphQL server uses this to generate the JWT.
CREATE FUNCTION private.authenticate(email text, PASSWORD text)
  RETURNS private.jwt_token
  AS $$
DECLARE
  account private.admin_account;
BEGIN
  SELECT
    a.* INTO account
  FROM
    private.admin_account AS a
  WHERE
    a.email = $1;
  IF account.password_hash = crypt(PASSWORD, account.password_hash) THEN
    RETURN (account.role,
      account.id,
      extract(epoch FROM (now() + interval '1:00:00')))::private.jwt_token;
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE plpgsql STRICT SECURITY DEFINER;

COMMENT ON FUNCTION private.authenticate(text, text) IS 'Creates a JWT token that will securely identify a person and give them certain permissions. This token expires in 1 hours.';

GRANT EXECUTE ON FUNCTION private.authenticate(text, text) TO :"dbUser", "cat_anon", "cat_admin";

-- Test it works with the default user.
SELECT
  private.authenticate(:'adminUserEmail', :'adminUserPw');

