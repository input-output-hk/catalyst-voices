-- Check aws tables status
-- Template.
SELECT keyspace_name FROM system_schema.keyspaces WHERE keyspace_name='{{keyspace_name}}';